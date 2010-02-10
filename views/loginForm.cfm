<cfsilent>
	<cfset myself = request.requestState.myself />
	<cfset submitEvent = request.requestState.submitEvent />
</cfsilent>

<cfoutput>
	<h1>Please Log In</h1>
			
	<form action="#myself##submitEvent#" method="post">
	  	<label>Username<br />
	  	<input name="userName" type="text" maxlength="30" />
		</label>
		<label>Password<br />
		<input name="password" type="password" maxlength="30" />
		</label>
		<input type="submit" name="submit" value="Log In" class="adminbutton" />
	</form>
</cfoutput>