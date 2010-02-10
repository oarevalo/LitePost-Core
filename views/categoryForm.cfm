<cfsilent>
	<cfset categoryBean = request.requestState.categoryBean />
	<cfset isAdmin = request.requestState.isAdmin />
	<cfset myself = request.requestState.myself />
	
	<cfif categoryBean.getCategoryID() gt 0>
		<cfset label="Update" />
	<cfelse>
		<cfset label="Create" />
	</cfif>
</cfsilent>

<cfoutput>
	<h1>#label# Category</h1>
	
	<form id="editCategory" name="editCategory" method="post" action="#myself#saveCategory">
		<input type="hidden" name="categoryID" value="#categoryBean.getCategoryID()#" />
		<label>Category<br />
		<input name="category" type="text" value="#categoryBean.getCategory()#" />
		</label>
		<input type="submit" name="submit" value="#label#" class="adminbutton" />
	</form>
</cfoutput>