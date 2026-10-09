<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - SmartDNS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>

<script>
var $j = jQuery.noConflict();

$j(document).ready(function() {
	init_itoggle('smartdns_enable', change_smartdns_enabled);
	init_itoggle('smartdns_dualstack', function(){});
});

function initial(){
	show_banner(1);
	show_menu(8,15,0);
	show_footer();

	if(!found_app_smartdns()){
		showhide_div('div_smartdns', 0);
		showhide_div('smartdns_port', 0);
		showhide_div('smartdns_servers', 0);
		showhide_div('smartdns_cache', 0);
		showhide_div('smartdns_speed', 0);
		showhide_div('smartdns_dualstack', 0);
		showhide_div('smartdns_ttl', 0);
	}else{
		change_smartdns_enabled();
	}
	init_smartdns_speed();
	init_smartdns_servers();
}

function change_smartdns_enabled(){
	var v = document.form.smartdns_enable[0].checked;
	showhide_div('smartdns_port', v);
	showhide_div('smartdns_servers', v);
	showhide_div('smartdns_cache', v);
	showhide_div('smartdns_speed', v);
	showhide_div('smartdns_dualstack', v);
	showhide_div('smartdns_ttl', v);
}

function applyRule(){
	compose_smartdns_speed();
	sd_compose_servers();
	showLoading();
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_SmartDNS_Content.asp";
	document.form.next_page.value = "";
	document.form.submit();
}

/* ===== 测速选优（三框） ===== */
function init_smartdns_speed(){
	var raw = document.form.smartdns_speed_check.value;
	var parts = (raw && raw.length) ? raw.split(',') : [];
	var sels = ['smartdns_speed_1','smartdns_speed_2','smartdns_speed_3'];
	for (var i=0;i<3;i++){
		var v = (i < parts.length) ? parts[i] : 'none';
		if (v !== 'ping' && v !== 'tcp:80' && v !== 'tcp:443') v = 'none';
		document.getElementById(sels[i]).value = v;
	}
}
function compose_smartdns_speed(){
	var sels = ['smartdns_speed_1','smartdns_speed_2','smartdns_speed_3'];
	var seen = {}, out = [];
	for (var i=0;i<3;i++){
		var v = document.getElementById(sels[i]).value;
		if (v === 'none' || seen[v]) continue;
		seen[v] = 1; out.push(v);
	}
	document.form.smartdns_speed_check.value = (out.length ? out.join(',') : 'none');
}

/* ===== 上游 DNS（动态增删 + 预设/自定义） ===== */
var SD_PRESETS = [
 {g:"国内 UDP(53)", i:[
   {t:"udp",v:"223.5.5.5:53",l:"阿里 DNS 223.5.5.5"},
   {t:"udp",v:"223.6.6.6:53",l:"阿里 DNS 223.6.6.6"},
   {t:"udp",v:"119.29.29.29:53",l:"腾讯 DNSPod 119.29.29.29"},
   {t:"udp",v:"180.76.76.76:53",l:"百度 DNS 180.76.76.76"},
   {t:"udp",v:"114.114.114.114:53",l:"114 DNS 114.114.114.114"}]},
 {g:"国内 TCP", i:[
   {t:"tcp",v:"223.5.5.5:53",l:"阿里 DNS 223.5.5.5 (TCP)"},
   {t:"tcp",v:"119.29.29.29:53",l:"腾讯 DNSPod 119.29.29.29 (TCP)"}]},
 {g:"国内 DoT(853)", i:[
   {t:"tls",v:"dns.alidns.com:853",l:"阿里 DoT dns.alidns.com"},
   {t:"tls",v:"dot.pub:853",l:"腾讯 DoT dot.pub"},
   {t:"tls",v:"dns.360.cn:853",l:"360 DoT dns.360.cn"}]},
 {g:"国内 DoH", i:[
   {t:"https",v:"https://dns.alidns.com/dns-query",l:"阿里 DoH"},
   {t:"https",v:"https://doh.pub/dns-query",l:"腾讯 DoH"},
   {t:"https",v:"https://doh.360.cn/dns-query",l:"360 DoH"}]},
 {g:"国外 UDP(53)", i:[
   {t:"udp",v:"8.8.8.8:53",l:"Google 8.8.8.8"},
   {t:"udp",v:"8.8.4.4:53",l:"Google 8.8.4.4"},
   {t:"udp",v:"1.1.1.1:53",l:"Cloudflare 1.1.1.1"},
   {t:"udp",v:"1.0.0.1:53",l:"Cloudflare 1.0.0.1"},
   {t:"udp",v:"9.9.9.9:53",l:"Quad9 9.9.9.9"},
   {t:"udp",v:"208.67.222.222:53",l:"OpenDNS 208.67.222.222"},
   {t:"udp",v:"94.140.14.14:53",l:"AdGuard 94.140.14.14"}]},
 {g:"国外 TCP", i:[
   {t:"tcp",v:"8.8.8.8:53",l:"Google 8.8.8.8 (TCP)"},
   {t:"tcp",v:"1.1.1.1:53",l:"Cloudflare 1.1.1.1 (TCP)"}]},
 {g:"国外 DoT(853)", i:[
   {t:"tls",v:"dns.google:853",l:"Google DoT dns.google"},
   {t:"tls",v:"1.1.1.1:853",l:"Cloudflare DoT 1.1.1.1"},
   {t:"tls",v:"dns.quad9.net:853",l:"Quad9 DoT dns.quad9.net"},
   {t:"tls",v:"dns.adguard.com:853",l:"AdGuard DoT dns.adguard.com"}]},
 {g:"国外 DoH", i:[
   {t:"https",v:"https://dns.google/dns-query",l:"Google DoH"},
   {t:"https",v:"https://cloudflare-dns.com/dns-query",l:"Cloudflare DoH"},
   {t:"https",v:"https://dns.quad9.net/dns-query",l:"Quad9 DoH"},
   {t:"https",v:"https://dns.adguard.com/dns-query",l:"AdGuard DoH"}]}
];

function sd_preset_options(){
	var h = '<option value="__custom__">自定义…</option>';
	for (var i=0;i<SD_PRESETS.length;i++){
		h += '<optgroup label="'+SD_PRESETS[i].g+'">';
		for (var j=0;j<SD_PRESETS[i].i.length;j++){
			var it = SD_PRESETS[i].i[j];
			h += '<option value="'+it.t+'|'+it.v+'">'+it.l+'</option>';
		}
		h += '</optgroup>';
	}
	return h;
}
function sd_render_row(enc){
	var list = document.getElementById('sd_servers_list');
	var div = document.createElement('div');
	div.style.marginBottom = '4px';
	var sel = document.createElement('select');
	sel.className = 'input'; sel.style.width = '300px';
	sel.innerHTML = sd_preset_options();
	var cust = document.createElement('span');
	cust.style.display = 'none';
	cust.innerHTML = ' 协议<select class="input sd_ptype" style="width:90px">'+
		'<option value="udp">UDP</option><option value="tcp">TCP</option>'+
		'<option value="tls">DoT</option><option value="https">DoH</option></select>'+
		' 地址<input class="input sd_pval" style="width:300px" placeholder="host:port 或 https://.../dns-query" />';
	var del = document.createElement('button');
	del.type='button'; del.className='btn btn-small'; del.textContent='− 减少';
	del.onclick = function(){ list.removeChild(div); };
	sel.onchange = function(){ cust.style.display = (sel.value === '__custom__') ? '' : 'none'; };
	if (enc){
		if (enc.indexOf('|') > 0){
			sel.value = enc;
		} else {
			sel.value = '__custom__'; cust.style.display='';
			cust.querySelector('.sd_ptype').value = 'udp';
			cust.querySelector('.sd_pval').value = enc;
		}
	}
	div.appendChild(sel); div.appendChild(cust); div.appendChild(del);
	list.appendChild(div);
}
function sd_add_server(){ sd_render_row(''); }
function sd_compose_servers(){
	var list = document.getElementById('sd_servers_list');
	var rows = list.children, out = [];
	for (var i=0;i<rows.length;i++){
		var sel = rows[i].querySelector('select');
		if (sel.value === '__custom__'){
			var p = rows[i].querySelector('.sd_ptype').value;
			var v = rows[i].querySelector('.sd_pval').value.trim();
			if (v) out.push(p+'|'+v);
		} else if (sel.value){
			out.push(sel.value);
		}
	}
	document.form.smartdns_servers.value = out.join(' ');
}
function init_smartdns_servers(){
	var raw = document.form.smartdns_servers.value;
	var arr = (raw && raw.length) ? raw.split(' ') : [];
	if (arr.length === 0) arr = ['udp|223.5.5.5:53','udp|119.29.29.29:53'];
	for (var i=0;i<arr.length;i++) sd_render_row(arr[i]);
}
</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
    <div class="container-fluid" style="padding-right: 0px">
        <div class="row-fluid">
            <div class="span3"><center><div id="logo"></div></center></div>
            <div class="span9" >
                <div id="TopBanner"></div>
            </div>
        </div>
    </div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">

    <input type="hidden" name="current_page" value="Advanced_SmartDNS_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="LANHostConfig;General;Storage;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">

    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span3">
                <!--Sidebar content-->
                <!--=====Beginning of Main Menu=====-->
                <div class="well sidebar-nav side_nav" style="padding: 0px;">
                    <ul id="mainMenu" class="clearfix"></ul>
                    <ul class="clearfix">
                        <li>
                            <div id="subMenu" class="accordion"></div>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="span9">
                <!--Body content-->
                <div class="row-fluid">
                    <div class="span12">
                        <div class="box well grad_colour_dark_blue">
                            <h2 class="box_head round_top">SmartDNS</h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr> <th colspan="2" style="background-color: #E3E3E3;">SmartDNS 基本设置</th> </tr>

                                        <tr id="div_smartdns">
                                            <th width="50%">SmartDNS 开关</th>
                                            <td colspan="2">
                                                <div class="main_itoggle">
                                                    <div id="smartdns_enable_on_of">
                                                        <input type="checkbox" id="smartdns_enable_fake" <% nvram_match_x("", "smartdns_enable", "1", "value=1 checked"); %><% nvram_match_x("", "smartdns_enable", "0", "value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="smartdns_enable" id="smartdns_enable_1" class="input" value="1" onclick="change_smartdns_enabled();" <% nvram_match_x("", "smartdns_enable", "1", "checked"); %>/>是
                                                    <input type="radio" name="smartdns_enable" id="smartdns_enable_0" class="input" value="0" onclick="change_smartdns_enabled();" <% nvram_match_x("", "smartdns_enable", "0", "checked"); %>/>否
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="smartdns_port">
                                            <th width="50%">本地端口</th>
                                            <td>
                                                <input type="text" maxlength="6" class="input" size="15" name="smartdns_port" style="width: 145px" value="<% nvram_get_x("","smartdns_port"); %>" />
                                                <br/><span class="explain">53 = SmartDNS 直连接管 DNS（推荐）；非 53 = dnsmasq 自动监听 53 并转发到 SmartDNS。</span>
                                            </td>
                                        </tr>
                                        <tr id="smartdns_servers">
                                            <th width="50%">上游 DNS</th>
                                            <td>
                                                <input type="hidden" name="smartdns_servers" value="<% nvram_get_x("","smartdns_servers"); %>" />
                                                <div id="sd_servers_list"></div>
                                                <button type="button" class="btn btn-small" onclick="sd_add_server()">+ 增加</button>
                                                <br/><span class="explain">逐条添加；下拉含国内外 UDP/TCP/DoT/DoH 预设，选「自定义」可填任意 地址:端口 或 DoT/DoH 地址（支持非标端口）。</span>
                                            </td>
                                        </tr>
                                        <tr id="smartdns_cache">
                                            <th width="50%">缓存条数</th>
                                            <td>
                                                <input type="text" maxlength="8" class="input" size="15" name="smartdns_cache" style="width: 145px" value="<% nvram_get_x("","smartdns_cache"); %>" />
                                            </td>
                                        </tr>
                                        <tr id="smartdns_speed">
                                            <th width="50%">测速选优模式</th>
                                            <td>
                                                <input type="hidden" name="smartdns_speed_check" value="<% nvram_get_x("","smartdns_speed_check"); %>" />
                                                <select id="smartdns_speed_1" class="input" style="width: 120px">
                                                    <option value="ping">Ping</option>
                                                    <option value="tcp:80">TCP:80</option>
                                                    <option value="tcp:443">TCP:443</option>
                                                    <option value="none">无</option>
                                                </select>
                                                <select id="smartdns_speed_2" class="input" style="width: 120px">
                                                    <option value="ping">Ping</option>
                                                    <option value="tcp:80">TCP:80</option>
                                                    <option value="tcp:443">TCP:443</option>
                                                    <option value="none">无</option>
                                                </select>
                                                <select id="smartdns_speed_3" class="input" style="width: 120px">
                                                    <option value="ping">Ping</option>
                                                    <option value="tcp:80">TCP:80</option>
                                                    <option value="tcp:443">TCP:443</option>
                                                    <option value="none">无</option>
                                                </select>
                                                <br/><span class="explain">三个框按顺序触发（每级间隔 200ms）。选「无」= 该位置留空；三个都为「无」即关闭测速。重复模式会自动合并。</span>
                                            </td>
                                        </tr>
                                        <tr id="smartdns_dualstack">
                                            <th width="50%">双栈 IP 优选</th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="smartdns_dualstack_on_of">
                                                        <input type="checkbox" id="smartdns_dualstack_fake" <% nvram_match_x("","smartdns_dualstack","1","value=1 checked"); %><% nvram_match_x("","smartdns_dualstack","0","value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="smartdns_dualstack" id="smartdns_dualstack_1" class="input" value="1" <% nvram_match_x("","smartdns_dualstack","1","checked"); %>/>是
                                                    <input type="radio" name="smartdns_dualstack" id="smartdns_dualstack_0" class="input" value="0" <% nvram_match_x("","smartdns_dualstack","0","checked"); %>/>否
                                                </div>
                                                <br/><span class="explain">域名同时解析到 IPv4/IPv6 时，优先返回实测连通性更好的地址。</span>
                                            </td>
                                        </tr>
                                        <tr id="smartdns_ttl">
                                            <th width="50%">缓存最小 TTL(秒)</th>
                                            <td>
                                                <input type="text" maxlength="8" class="input" size="15" name="smartdns_ttl_min" style="width: 145px" value="<% nvram_get_x("","smartdns_ttl_min"); %>" />
                                                <br/><span class="explain">0 = 不限制；大于 0 时把缓存记录 TTL 抬高到该值，延长缓存有效期（降低上游压力）。</span>
                                            </td>
                                        </tr>

                                        <% smartdns_status(); %>
                                    </table>

                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="applyRule();" type="button" value="<#CTL_apply#>" /></center>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<div id="footer"></div>
</div>
</body>
</html>
