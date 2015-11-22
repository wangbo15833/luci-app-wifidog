local sys = require "luci.sys"
local fs = require "nixio.fs"
local uci = require "luci.model.uci".cursor()
local wan_ifname = luci.util.exec("uci get network.wan.ifname")
local lan_ifname = luci.util.exec("uci get network.lan.ifname")

m = Map("wifidog", "wifidog（web认证）客户端配置",translate("支持WIWIZ/FreeWifiBox等"))

if fs.access("/usr/bin/wifidog") then
	s = m:section(TypedSection, "settings", "认证站点配置")
	s.anonymous = true
	s.addremove = false
	s:tab("jbsz", translate("基本设置"))
	s:tab("bmd", translate("白名单"))
	s:tab("gjsz", translate("高级设置"))
	

	--[基本设置]--
	wifidog_enable = s:taboption("jbsz",Flag, "wifidog_enable", translate("启用认证"),translate("打开或关闭认证"))
	wifidog_enable.rmempty=false
	gatewayID = s:taboption("jbsz",Value,"gateway_id","设备id（GatewayID）","此处设置认证服务器端配置好的节点id")
	deamo_enable = s:taboption("jbsz",Flag, "deamo_enable", translate("守护进程"),"开启监护认证进程，保证认证进程时时在线")
	deamo_enable:depends("wifidog_enable","1")
	gateway_hostname = s:taboption("jbsz",Value,"gateway_hostname","认证服务器地址","域名或者IP地址")


	--[高级设置]--
	ssl_enable = s:taboption("gjsz",Flag, "ssl_enable", translate("加密传输"),"启用安全套接层协议传输，提高网络传输安全")
	ssl_enable.rmempty=false
	sslport = s:taboption("gjsz",Value,"sslport","SSL传输端口号","默认443")
	sslport:depends("ssl_enable","1")

	gatewayport = s:taboption("gjsz",Value,"gatewayport","认证网关端口号","默认端口号2060")
	gateway_httpport = s:taboption("gjsz",Value,"gateway_httpport","HTTP端口号","默认80端口")
	gateway_path = s:taboption("gjsz",Value,"gateway_path","认证服务器路径","最后要加/，例如：'/'，'/wifidog/'")
	gateway_connmax = s:taboption("gjsz",Value,"gateway_connmax","最大用户接入数量","以路由器性能而定，默认50")
	gateway_connmax.default = "50"
	check_interval = s:taboption("gjsz",Value,"check_interval","检查间隔","接入客户端在线检测间隔，默认60秒")
	check_interval.default = "60"
	client_timeout = s:taboption("gjsz",Value,"client_timeout","客户端超时","接入客户端认证超时，默认5分")
	client_timeout.default = "5"

	gateway_interface = s:taboption("gjsz",Value,"gateway_interface","内网接口","设置内网接口，默认'br-lan'。")
	gateway_interface.default = "br-lan"
	gateway_interface:value(wan_ifname,wan_ifname .."" )
	gateway_interface:value(lan_ifname,lan_ifname .. "")

	gateway_eninterface = s:taboption("gjsz",Value,"gateway_eninterface","外网接口","此处设置认证服务器的外网接口一般默认即可")
	gateway_eninterface.default = wan_ifname
	gateway_eninterface:value(wan_ifname,wan_ifname .."")
	gateway_eninterface:value(lan_ifname,lan_ifname .. "")

for _, e in ipairs(sys.net.devices()) do
	if e ~= "lo" then gateway_interface:value(e) end
	if e ~= "lo" then gateway_eninterface:value(e) end
end

	--[白名单]--
	bmd_url=s:taboption("bmd",Value,"bmd_url","网站URL白名单","编辑框内的url网址不认证也能打开，不能带”http://“多个URL请用”,“号隔开。如：“www.baidu.com,www.qq.com”")
	bmd_url.placeholder = "www.baidu.com,www.qq.com,www.163.com"
	myz_mac=s:taboption("bmd",Value,"myz_mac","免认证设备","填入设备的MAC地址，多个设备请用“,”号隔开。如：“11:22:33:44:55:66,aa:bb:cc:dd:ff:00”")
	myz_mac.placeholder = "00:11:22:33:44:55,AA:BB:CC:DD:EE:FF"

else
	m.pageaction = false
end

return m
	
