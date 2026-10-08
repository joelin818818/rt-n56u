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
	}else{
		change_smartdns_enabled();
	}
}

function change_smartdns_enabled(){
	var v = document.form.smartdns_enable[0].checked;
	showhide_div('smartdns_port', v);
	showhide_div('smartdns_servers', v);
	showhide_div('smartdns_cache', v);
}

function applyRule(){
	showLoading();
	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_SmartDNS_Content.asp";
	document.form.next_page.value = "";
	document.form.submit();
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
                                                <input type="text" maxlength="256" class="input" size="60" name="smartdns_servers" value="<% nvram_get_x("","smartdns_servers"); %>" /><br/>
                                                <span class="explain">空格分隔，例如 223.5.5.5:53 119.29.29.29:53</span>
                                            </td>
                                        </tr>
                                        <tr id="smartdns_cache">
                                            <th width="50%">缓存条数</th>
                                            <td>
                                                <input type="text" maxlength="8" class="input" size="15" name="smartdns_cache" style="width: 145px" value="<% nvram_get_x("","smartdns_cache"); %>" />
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
