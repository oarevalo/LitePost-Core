<cfcomponent extends="core.coreApp">

	<!--- Application settings --->
	<cfset this.name = "litepost-core"> 
	<cfset this.sessionManagement = true> 

	<!--- Framework settings --->
	<cfset this.mainHandler = "main">
	<cfset this.defaultEvent = "home">
	<cfset this.defaultLayout = "layout.main">

	<!--- Setup paths --->
	<cfset this.dirs.handlers = "handlers">
	<cfset this.dirs.layouts = "layouts">
	<cfset this.dirs.views = "views">

	<!--- Provide a config for settings and services --->
	<cfset this.configDoc = "config/config.xml.cfm">
	
</cfcomponent>
