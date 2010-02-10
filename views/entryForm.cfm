<cfsilent>
	<cfset entryBean = request.requestState.entryBean />
	<cfset categories = request.requestState.categories />
	<cfset submitEvent = request.requestState.submitEvent />
	<cfset isAdmin = request.requestState.isAdmin />
	<cfset myself = request.requestState.myself />
	
	<cfif entryBean.getEntryID() GT 0>
		<cfset label = "Update" />
	<cfelse>
		<cfset label = "Add" />
	</cfif>
</cfsilent>

<cfoutput>

	<h1>#label# Entry</h1>
	
	<form id="editEntry" name="editEntry" action="#myself##submitEvent#" method="post">
		<input type="hidden" name="entryID" value="#entryBean.getEntryID()#" />
		<label>Title<br />
		<input name="title" type="text" value="#entryBean.getTitle()#" />
		</label>
		<label>Category<br />
		<cfset currCatID = entryBean.getCategoryID() />
		<select name="categoryID">
			<option value="-1" selected>- Select -</option>
			<option value="0" <cfif currCatID EQ 0>selected</cfif>>- None -</option>
			<cfloop from="1" to="#arrayLen(categories)#" index="i">
				<cfset category = categories[i] />
				<option value="#category.getCategoryID()#"<cfif currCatID eq entryBean.getCategoryID()> selected</cfif>>#category.getCategory()#</option>
			</cfloop>
		</select>
		</label>
		<label>Entry<br />
		<textarea name="body" class="entry" cols="" rows="">#entryBean.getBody()#</textarea>
		</label>
		<input type="submit" name="submit" value="#label# Entry" class="adminbutton" />
	</form>
	
</cfoutput>