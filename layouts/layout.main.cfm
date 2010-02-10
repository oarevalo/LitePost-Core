<cfset rs = request.requestState>
<cfparam name="rs.viewTemplatePath" default="">
<cfparam name="rs.messageTemplatePath" default="">
<cfparam name="rs.isAdmin" default="false">
<cfparam name="rs.contentright" default="">
<cfparam name="rs.myself" default="">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>litePost blog</title>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">

	<style type="text/css" media="all">
	<!--
	@import url("../assets/css/lp_layout.css");
	@import url("../assets/css/lp_text.css");
	@import url("../assets/css/lp_forms.css");
	-->
	</style>

</head>

<body>

<!-- display divider-->
<div id="bar">&nbsp;</div>

<cfoutput>
<!-- main container -->
<div id="container">

	<!-- login/out button -->
	<cfif rs.isAdmin>
		<a href="#rs.myself#logout" id="loginbutton" class="adminbutton">Log Out</a>
	<cfelse>
		<a href="#rs.myself#loginForm" id="loginbutton" class="adminbutton">Log In</a>
	</cfif>
	
	<!-- header block -->
	<div id="header"><a href="index.cfm"><img src="../assets/images/litePost_logo.gif" alt="litePost" border="0" /></a></div>
	
	<!-- wrapper block to constrain widths -->
	<div id="wrapper">
		<!-- begin body content -->
		<div id="content">
			<!-- app/error messages -->
			<cfinclude template="#rs.messageTemplatePath#">
			
			<!-- anchor to top of content, also used for skip to content links-->
			<a name="content"></a>
			
			<!-- content -->
			<cfif rs.viewTemplatePath neq "">
				<cfinclude template="#rs.viewTemplatePath#">
			</cfif>
		
	  	</div>
		
	</div>
	<!-- navigation -->
	<div id="navigation">
		<cfinclude template="../views/categories.cfm">		
		<cfinclude template="../views/bookmarks.cfm">		
	</div>
	
	<!-- site footer-->
	<div id="footer"><p>LitePost is made under the Creative Commons license! (or something like that)</p></div>
	
</div>
</cfoutput>

</body>
</html>