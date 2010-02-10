<cfcomponent extends="litepost.core.core.eventHandler">

	<cffunction name="onApplicationStart">
		<!--- application initialization code goes here --->
		<cfset getService("beanFactory").loadBeans( getSetting("coldspringConfigPath") )>
	</cffunction>

	<cffunction name="onRequestStart" access="public" returntype="void">
		<cfset var bf = getService("beanFactory")>
		<cfset var event = getValue("event")>

		<cfset setValue("myself","index.cfm?event=")>
		<cfset setValue("isAdmin", bf.getBean("securityService").isAuthenticated() ) />
		<cfset setValue("bookmarks", bf.getBean("bookmarkService").getBookmarks() ) />
		<cfset setValue("categories", bf.getBean("categoryService").getCategoriesWithCounts() ) />
	</cffunction>



	<!--- 'Display' Events --->

	<cffunction name="home" access="public" returntype="void">
		<cfset entries()>
	</cffunction>

	<cffunction name="entries" access="public" returntype="void">
		<!--- This is an example of an event handler. --->
		<cfset var categoryID = getValue("categoryID",0) />
		<cfset var entries = 0 />
		<cfset var entryService = getService("beanFactory").getBean("entryService")>
		
		<cfif categoryID GT 0>
			<cfset entries = entryService.getEntriesByCategoryID(categoryID) />
		<cfelse>
			<cfset entries = entryService.getEntries() />
		</cfif>
		
		<cfset setValue("entries", entries) />
		<cfset setView("entries")>
	</cffunction>

	<cffunction name="comments" access="public" returntype="void">
		<cfset var entryID = getValue("entryID",0) />
		<cfset var entry = getService("beanFactory").getBean("entryService").getEntryByID(entryID, true) />
		
		<cfif entry.isNull()>
			<cfset setNextEvent("entries")>
		<cfelse>
			<cfset setValue("entry", entry) />
		</cfif>
		
		<cfset commentBean = createObject("component","net.litepost.component.comment.Comment").init() />
		<cfset setValue("commentBean", commentBean) />
		<cfset setView("comments")>
	</cffunction>

	<cffunction name="loginForm" access="public" returntype="void">
		<cfset setValue("submitEvent","login")>
		<cfset setView("loginForm")>
	</cffunction>

	<cffunction name="entryForm" access="public" returntype="void">
		<cfset setValue("submitEvent","saveEntry")>
		<cfset setView("entryForm")>
	</cffunction>

	<cffunction name="categoryForm" access="public" returntype="void">
		<cfset setView("categoryForm")>
	</cffunction>

	<cffunction name="bookmarkForm" access="public" returntype="void">
		<cfset setView("bookmarkForm")>
	</cffunction>

	<cffunction name="blogRSS" access="public" returntype="void">
		<cfset var numEntriesOnHomePage = getSetting("numEntriesOnHomePage")/>
		<cfset var blogName = getSetting("blogName")/>
		<cfset var blogURL = getSetting("blogURL")/>
		<cfset var blogDescription = getSetting("blogDescription")/>
		<cfset var blogLanguage = getSetting("blogLanguage")/>
		<cfset var authorEmail = getSetting("authorEmail")/>
		<cfset var webmasterEmail = getSetting("webmasterEmail")/>
		<cfset var eventValue = "event" />
		
		<cfset var categoryID = getValue("categoryID",0)/>
		<cfset var categoryName = getValue("categoryName","")/>
		
		<cfset var rss = ""/>
		<cfset var rssService = getService("beanFactory").getBean("rssService")>
		
		<cfif getValue("category",false)>
			<cfset rss = rssService.getCategoryRSS(categoryID, 
													"Category: " & categoryID,  
													blogName, 
													blogURL, 
													blogDescription, 
													replace(lcase(blogLanguage), "_", "-", "one"), 
													"LitePost", 
													authorEmail, 
													webmasterEmail, 
													eventValue) />
		<cfelse>
			<cfset rss = rssService.getBlogRSS(numEntriesOnHomePage, 
													blogName, 
													blogURL, 
													blogDescription, 
													replace(lcase(blogLanguage), "_", "-", "one"), 
													"LitePost", 
													authorEmail, 
													webmasterEmail, 
													eventValue) />
		</cfif>
												
		<cfset setValue("rss", rss) />
		<cfset setLayout("") />
		<cfset setView("rss") />
	</cffunction>

	<cffunction name="categoryRSS" access="public" returntype="void">
		<cfset setValue("category",true)>
		<cfset blogRSS()>
	</cffunction>


	<!--- 'Action' Events --->

	<cffunction name="login" access="public" returntype="void">
		<cfset var username = getValue("username","") />
		<cfset var password = getValue("password","") />
		<cfset var user = getService("beanFactory").getBean("userService").authenticate(username, password)>
		
		<cfif user.isNull()>
			<cfset setMessage("warning","User not found!")>
			<cfset setNextEvent("loginForm") />
		<cfelse>
			<cfset setNextEvent("home") />
		</cfif>
	</cffunction>

	<cffunction name="logout" access="public" returntype="void">
		<cfset getService("beanFactory").getBean("securityService").removeUserSession() />
		<cfset setNextEvent("home") />
	</cffunction>

	<cffunction name="addEntry" access="public" returntype="void">
		<cfset var entryBean = createObject("component","net.litepost.component.entry.Entry").init() />
		<cfset setValue("entryBean", entryBean) />
		<cfset entryForm()>
	</cffunction>

	<cffunction name="editEntry" access="public" returntype="void">
		<cfset var entryID = getValue("entryID",0) />
		<cfset var entry = getService("beanFactory").getBean("entryService").getEntryByID(entryID, false) />
		
		<cfif entry.isNull()>
			<cfset setNextEvent("home")>
		<cfelse>
			<cfset setValue("entryBean", entry) />
		</cfif>
		
		<cfset entryForm()>
	</cffunction>

	<cffunction name="saveEntry" access="public" returntype="void">
		<cfset var entryBean = createObject("component","net.litepost.component.entry.Entry")
								.init(
										entryID = getValue("entryID"),
										categoryID = getValue("categoryID"),
										title = getValue("title"),
										body = getValue("body")
									) />
	
		<!--- validate the bean, add result based on validation--->
		<cfif entryBean.validate()>
			<cfset getService("beanFactory").getBean("entryService").saveEntry(entryBean) />
			<cfset setNextEvent("home")>
		<cfelse>
			<cfset setMessage("warning","Please complete entry form!")>
			<cfset setValue("entryBean", entryBean) />
			<cfset entryForm()>
		</cfif>
	</cffunction>

	<cffunction name="deleteEntry" access="public" returntype="void">
		<cfset var entryID = getValue("entryID",0) />
		<cftry>
			<cfset getService("beanFactory").getBean("entryService").removeEntry(entryID) />
			<cfcatch type="any">
				<cfset setMessage("error",cfcatch.message)>
			</cfcatch>
		</cftry>
		<cfset setNextEvent("home")>
	</cffunction>

	<cffunction name="saveComment" access="public" returntype="void">
		<cfset var commentBean = createObject("component","net.litepost.component.comment.Comment") 
									.init(
											entryID = getValue("entryID"),
											comment = getValue("comment"),
											name = getValue("name"),
											email = getValue("email"),
											url = getValue("url")
										) />

		<!--- validate the bean, add result based on validation--->
		<cfif commentBean.validate()>
			<cfset getService("beanFactory").getBean("commentService").saveComment(commentBean) />
			<cfset setNextEvent("home")>
		<cfelse>
			<cfset setMessage("warning","Please complete comments form!")>
			<cfset setValue("commentBean", commentBean) />
			<cfset comments()>
		</cfif>
	</cffunction>

	<cffunction name="addCategory" access="public" returntype="void">
		<cfset var categoryBean = createObject("component","net.litepost.component.category.Category").init() />
		<cfset setValue("categoryBean", categoryBean) />
		<cfset categoryForm()>
	</cffunction>

	<cffunction name="editCategory" access="public" returntype="void">
		<cfset var categoryID = getValue("categoryID",0) />
		<cfset var category = getService("beanFactory").getBean("categoryService").getCategoryByID(categoryID) />
		
		<cfif category.isNull()>
			<cfset setNextEvent("home")>
		<cfelse>
			<cfset setValue("categoryBean", category) />
		</cfif>
		
		<cfset categoryForm()>
	</cffunction>

	<cffunction name="saveCategory" access="public" returntype="void">
		<cfset var categoryBean = createObject("component","net.litepost.component.category.Category") 
									.init(
											categoryID = getValue("categoryID"),
											category = getValue("category")
										) />

		<!--- validate the bean, add result based on validation--->
		<cfif categoryBean.validate()>
			<cfset getService("beanFactory").getBean("categoryService").saveCategory(categoryBean) />
			<cfset setNextEvent("home")>
		<cfelse>
			<cfset setMessage("warning","Please complete category form!")>
			<cfset setValue("categoryBean", categoryBean) />
			<cfset categoryForm()>
		</cfif>

	</cffunction>

	<cffunction name="deleteCategory" access="public" returntype="void">
		<cfset var categoryID = getValue("categoryID",0) />
		<cfset var category = getService("beanFactory").getBean("categoryService").removeCategory(categoryID) />
		<cfset setNextEvent("home")>
	</cffunction>

	<cffunction name="addBookmark" access="public" returntype="void">
		<cfset var bookmarkBean = createObject("component","net.litepost.component.bookmark.Bookmark").init() />
		<cfset setValue("bookmarkBean", bookmarkBean) />
		<cfset bookmarkForm()>
	</cffunction>

	<cffunction name="editBookmark" access="public" returntype="void">
		<cfset var bookmarkID = getValue("bookmarkID",0) />
		<cfset var bookmark = getService("beanFactory").getBean("bookmarkService").getBookmarkByID(bookmarkID) />
		
		<cfif bookmark.isNull()>
			<cfset setNextEvent("home")>
		<cfelse>
			<cfset setValue("bookmarkBean", bookmark) />
		</cfif>
		
		<cfset bookmarkForm()>
	</cffunction>

	<cffunction name="saveBookmark" access="public" returntype="void">
		<cfset var bookmarkBean = createObject("component","net.litepost.component.bookmark.Bookmark") 
									.init(
											bookmarkID = getValue("bookmarkID"),
											name = getValue("name"),
											url = getValue("url")
										) />

		<!--- validate the bean, add result based on validation--->
		<cfif bookmarkBean.validate()>
			<cfset getService("beanFactory").getBean("bookmarkService").saveBookmark(bookmarkBean) />
			<cfset setNextEvent("home")>
		<cfelse>
			<cfset setMessage("warning","Please complete bookmark form!")>
			<cfset setValue("bookmarkBean", bookmarkBean) />
			<cfset bookmarkForm()>
		</cfif>
	</cffunction>

	<cffunction name="deleteBookmark" access="public" returntype="void">
		<cfset var bookmarkID = getValue("bookmarkID",0) />
		<cftry>
			<cfset getService("beanFactory").getBean("bookmarkService").removeBookmark(bookmarkID) />
			<cfcatch type="any">
				<cfset setMessage("error",cfcatch.message)>
			</cfcatch>
		</cftry>
		<cfset setNextEvent("home")>
	</cffunction>

</cfcomponent>