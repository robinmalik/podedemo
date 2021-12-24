
function BuildHead($PageTitle)
{
	Write-Output "		<title>$($PageTitle)</title>"
	Write-Output "		<script src=`"https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js`"></script>"

	Write-Output "		<!-- Bootstrap core CSS -->"
	Write-Output "		<link href=`"/css/bootstrap.min.css`" rel=`"stylesheet`">"
	Write-Output "		<link href=`"/css/lu-loader-running.css`" rel=`"stylesheet`">"
	Write-Output "		<link href=`"/css/lu-loader-completed.css`" rel=`"stylesheet`">"

	Write-Output "		<style>"
	Write-Output "			.bd-placeholder-img {"
	Write-Output "				font-size: 1.125rem;"
	Write-Output "				text-anchor: middle;"
	Write-Output "				-webkit-user-select: none;"
	Write-Output "				-moz-user-select: none;"
	Write-Output "				user-select: none;"
	Write-Output "			}"

	Write-Output "			@media (min-width: 768px) {"
	Write-Output "				.bd-placeholder-img-lg {"
	Write-Output "					font-size: 3.5rem;"
	Write-Output "				}"
	Write-Output "			}"
	Write-Output "		</style>"

	Write-Output "		<!-- Custom styles for this template -->"
	Write-Output "		<link href=`"/css/navbar-top-fixed.css`" rel=`"stylesheet`">"
}

function BuildNav($WebsiteName)
{
	Write-Output "		<nav class=`"navbar navbar-expand-md navbar-dark fixed-top bg-dark`">"
	Write-Output "			<div class=`"container-fluid`">"
	Write-Output "				<a class=`"navbar-brand`" href=`"#`">$WebSiteName</a>"
	Write-Output "				<button class=`"navbar-toggler`" type=`"button`" data-bs-toggle=`"collapse`" data-bs-target=`"#navbarCollapse`" aria-controls=`"navbarCollapse`" aria-expanded=`"false`" aria-label=`"Toggle navigation`">"
	Write-Output "					<span class=`"navbar-toggler-icon`"></span>"
	Write-Output "				</button>"
	Write-Output "				<div class=`"collapse navbar-collapse`" id=`"navbarCollapse`">"
	Write-Output "					<ul class=`"navbar-nav me-auto mb-2 mb-md-0`">"
	Write-Output "						<li class=`"nav-item`">"
	Write-Output "							<a class=`"nav-link active`" aria-current=`"page`" href=`"#`">Home</a>"
	Write-Output "						</li>"
	Write-Output "						<li class=`"nav-item`">"
	Write-Output "							<a class=`"nav-link`" href=`"#`">Link</a>"
	Write-Output "						</li>"
	Write-Output "						<li class=`"nav-item`">"
	Write-Output "							<a class=`"nav-link disabled`" href=`"#`" tabindex=`"-1`" aria-disabled=`"true`">Disabled</a>"
	Write-Output "						</li>"
	Write-Output "					</ul>"
	Write-Output "					<form class=`"d-flex`">"
	Write-Output "						<input class=`"form-control me-2`" type=`"search`" placeholder=`"Search`" aria-label=`"Search`">"
	Write-Output "						<button class=`"btn btn-outline-success`" type=`"submit`">Search</button>"
	Write-Output "					</form>"
	Write-Output "				</div>"
	Write-Output "			</div>"
	Write-Output "		</nav>"
}

function BuildForm($PageData)
{
	$formname = ($PageData.PageTitle.ToLower()) -replace " ", "-"
	Write-Output "<div class=`"container form-striped`" id=`"container-form`">`r`n"
	Write-Output "<form class=`"form`" name=`"$formname`" id=`"$formname`">`r`n"
	foreach($Field in $PageData.InputFields)
	{
		$FieldName = $Field.name.ToLower()
		if($Field.type -eq 'text')
		{
			Write-Output "<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-$FieldName`">"
			Write-Output "	<label for=`"$FieldName`" class=`"col-sm-3 col-form-label font-weight-bold`">$($Field.label)</label>"
			Write-Output "	<div class=`"col-sm-9`">"
			Write-Output "		<input type=`"text`" class=`"form-control`" name=`"$FieldName`" id=`"$FieldName`" placeholder=`"$($Field.label)`" value=`"`" autofocus>"
			Write-Output "	</div>"
			Write-Output "</div>"
		}

		if($Field.type -eq 'password')
		{
			Write-Output "<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-$FieldName`">"
			Write-Output "	<label for=`"$FieldName`" class=`"col-sm-3 col-form-label font-weight-bold`">$($Field.label)</label>"
			Write-Output "	<div class=`"col-sm-9`">"
			Write-Output "		<input type=`"password`" class=`"form-control`" name=`"$FieldName`" id=`"$FieldName`" placeholder=`"$($Field.label)`" value=`"`" autofocus>"
			Write-Output "	</div>"
			Write-Output "</div>"
		}

		if($Field.type -eq 'select')
		{
			Write-Output "			<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-$FieldName`">"
			Write-Output "				<label for=`"$FieldName`" class=`"col-sm-3 col-form-label font-weight-bold`">$($Field.label)</label>"
			Write-Output "				<div class=`"col-sm-9 pt-1`">"
			Write-Output "						<select name=`"$FieldName`" id=`"$FieldName`" class=`"form-control chosen-select`">"
			Write-Output "							<option selected></option>"
			foreach($Option in $Field.options)
			{
				Write-Output "							<option value=`"$($Option.value)`">$($Option.Option)</option>"
			}
			Write-Output "						</select>"
			Write-Output "				</div>"
			Write-Output "			</div>"
		}

		if($Field.type -eq 'checkbox')
		{
			Write-Output "<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-$FieldName`">"
			Write-Output "	<div class=`"col-sm-3 font-weight-bold`">$($Field.label)</div>"
			Write-Output "		<div class=`"col-sm-9`">"
			Write-Output "			<div class=`"form-check`">"
			Write-Output "				<input class=`"form-check-input`" type=`"checkbox`" id=`"$FieldName`" name=`"$FieldName`">"
			Write-Output "				<label class=`"form-check-label`" for=`"$FieldName`"></label>"
			Write-Output "		</div>"
			Write-Output "	</div>"
			Write-Output "</div>"
		}

		if($Field.type -eq 'radio')
		{

		}
	}

	if($PageData.CaseNumberRequired -eq $True)
	{
		Write-Output "<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-casenumber`">"
		Write-Output "	<label for=`"casenumber`" class=`"col-sm-3 col-form-label font-weight-bold`">Case Number</label>"
		Write-Output "	<div class=`"col-sm-9`">"
		Write-Output "		<input type=`"text`" class=`"form-control`" name=`"casenumber`" id=`"casenumber`" placeholder=`"Case Number`" value=`"`" autofocus>"
		Write-Output "	</div>"
		Write-Output "</div>"
	}

	Write-Output "<div class=`"form-group row py-3 mx-0`">"
	Write-Output "	<div class=`"col-sm-12`">"
	Write-Output "		<button type=`"submit`" class=`"btn btn-primary`" name=`"submit`" id=`"submit`">$($PageData.SubmitButtonText)</button>"
	Write-Output "	</div>"
	Write-Output "</div>"

	Write-Output '</form>'
	Write-Output '</div>'
}