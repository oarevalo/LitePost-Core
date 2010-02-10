<cfsilent>
	<cfset bookmarkBean = request.requestState.bookmarkBean />
	<cfset isAdmin = request.requestState.isAdmin />
	<cfset myself = request.requestState.myself />
	
	<cfif bookmarkBean.getBookmarkID() gt 0>
		<cfset label="Update" />
	<cfelse>
		<cfset label="Create" />
	</cfif>
</cfsilent>

<cfoutput>
	<h1>#label# Link</h1>
	
	<form id="editBookmark" name="editBookmark" method="post" action="#myself#saveBookmark">
		<input type="hidden" name="bookmarkID" value="#bookmarkBean.getBookmarkID()#" />
		<label>Name<br />
		<input name="name" type="text" value="#bookmarkBean.getName()#" />
		</label>
		<label>Url<br />
		<input name="url" type="text" value="#bookmarkBean.getUrl()#" />
		</label>
		<input type="submit" name="submit" value="#label#" class="adminbutton" />
	</form>
</cfoutput>