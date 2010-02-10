<?xml version="1.0" encoding="ISO-8859-1"?>
<config>
	<!-- This section describes application-specific settings -->
	<settings>
		<Setting name="coldspringConfigPath" value="/litepost/config/litepost-services.xml" />
		<Setting name="blogName" value="LitePost - Core Edition" />
		<Setting name="blogURL" value="http://localhost/litepost/core" />
		<Setting name="blogDescription" value="The Core Edition of LitePost" />
		<Setting name="blogLanguage" value="en_US" />
		<Setting name="numEntriesOnHomePage" value="20" />
		<Setting name="authorEmail" value="oarevalo@gmail.com" />
		<Setting name="webmasterEmail" value="oarevalo@gmail.com" />
	</settings>

	<!-- This section describes all services that will be loaded into the application -->
	<services>
		<service name="beanFactory" class="coldspring.beans.DefaultXmlBeanFactory">
		</service>
	</services>

</config>

