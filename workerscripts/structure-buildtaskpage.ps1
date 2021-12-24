
# Note use of `r`n at the end of Write-Output lines, and also specific levels of tabbed indentation.
# This is so that HTML is rendered nicely when viewing the source code (helps debugging).

function BuildHead($PageTitle)
{
	Write-Output "<title>$($PageTitle)</title>`r`n"
	Write-Output "		<script src=`"https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js`"></script>`r`n"
	Write-Output "`r`n"
	Write-Output "		<!-- Bootstrap core CSS -->`r`n"
	Write-Output "		<link href=`"/css/bootstrap.min.css`" rel=`"stylesheet`">`r`n"
	Write-Output "		<link href=`"/css/lu-loader-running.css`" rel=`"stylesheet`">`r`n"
	Write-Output "		<link href=`"/css/lu-loader-completed.css`" rel=`"stylesheet`">`r`n"
	Write-Output "`r`n"
	Write-Output "		<style>`r`n"
	Write-Output "			.bd-placeholder-img {`r`n"
	Write-Output "				font-size: 1.125rem;`r`n"
	Write-Output "				text-anchor: middle;`r`n"
	Write-Output "				-webkit-user-select: none;`r`n"
	Write-Output "				-moz-user-select: none;`r`n"
	Write-Output "				user-select: none;`r`n"
	Write-Output "			}"
	Write-Output "`r`n"
	Write-Output "			@media (min-width: 768px) {`r`n"
	Write-Output "				.bd-placeholder-img-lg {`r`n"
	Write-Output "					font-size: 3.5rem;`r`n"
	Write-Output "				}`r`n"
	Write-Output "			}`r`n"
	Write-Output "		</style>`r`n"
	Write-Output "`r`n"
	Write-Output "		<!-- Custom styles for this template -->`r`n"
	Write-Output "		<link href=`"/css/navbar-top-fixed.css`" rel=`"stylesheet`">`r`n"
}

function BuildNav($WebsiteName)
{
	Write-Output "<nav class=`"navbar navbar-expand-md navbar-dark fixed-top bg-dark`">`r`n"
	Write-Output "			<div class=`"container-fluid`">`r`n"
	Write-Output "				<a class=`"navbar-brand`" href=`"#`">$WebSiteName</a>`r`n"
	Write-Output "				<button class=`"navbar-toggler`" type=`"button`" data-bs-toggle=`"collapse`" data-bs-target=`"#navbarCollapse`" aria-controls=`"navbarCollapse`" aria-expanded=`"false`" aria-label=`"Toggle navigation`">`r`n"
	Write-Output "					<span class=`"navbar-toggler-icon`"></span>`r`n"
	Write-Output "				</button>`r`n"
	Write-Output "				<div class=`"collapse navbar-collapse`" id=`"navbarCollapse`">`r`n"
	Write-Output "					<ul class=`"navbar-nav me-auto mb-2 mb-md-0`">`r`n"
	Write-Output "						<li class=`"nav-item`">`r`n"
	Write-Output "							<a class=`"nav-link active`" aria-current=`"page`" href=`"#`">Home</a>`r`n"
	Write-Output "						</li>`r`n"
	Write-Output "						<li class=`"nav-item`">`r`n"
	Write-Output "							<a class=`"nav-link`" href=`"#`">Link</a>`r`n"
	Write-Output "						</li>`r`n"
	Write-Output "						<li class=`"nav-item`">`r`n"
	Write-Output "							<a class=`"nav-link disabled`" href=`"#`" tabindex=`"-1`" aria-disabled=`"true`">Disabled</a>`r`n"
	Write-Output "						</li>`r`n"
	Write-Output "					</ul>`r`n"
	Write-Output "					<form class=`"d-flex`">`r`n"
	Write-Output "						<input class=`"form-control me-2`" type=`"search`" placeholder=`"Search`" aria-label=`"Search`">`r`n"
	Write-Output "						<button class=`"btn btn-outline-success`" type=`"submit`">Search</button>`r`n"
	Write-Output "					</form>`r`n"
	Write-Output "				</div>`r`n"
	Write-Output "			</div>`r`n"
	Write-Output "		</nav>`r`n"
}

function BuildForm($PageData)
{
	$formname = ($PageData.PageTitle.ToLower()) -replace " ", "-"
	#Write-Output "<div class=`"container form-striped`" id=`"container-form`">`r`n"
	Write-Output "<form class=`"form`" name=`"$formname`" id=`"$formname`">`r`n"
	foreach($Field in $PageData.InputFields)
	{
		$FieldName = $Field.name.ToLower()
		if($Field.type -eq 'text')
		{
			Write-Output "					<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-$FieldName`">`r`n"
			Write-Output "						<label for=`"$FieldName`" class=`"col-sm-3 col-form-label font-weight-bold`">$($Field.label)</label>`r`n"
			Write-Output "						<div class=`"col-sm-9`">`r`n"
			Write-Output "							<input type=`"text`" class=`"form-control`" name=`"$FieldName`" id=`"$FieldName`" placeholder=`"$($Field.label)`" value=`"`" autofocus>`r`n"
			Write-Output "						</div>`r`n"
			Write-Output "					</div>`r`n"
		}

		if($Field.type -eq 'password')
		{
			Write-Output "					<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-$FieldName`">`r`n"
			Write-Output "						<label for=`"$FieldName`" class=`"col-sm-3 col-form-label font-weight-bold`">$($Field.label)</label>`r`n"
			Write-Output "						<div class=`"col-sm-9`">`r`n"
			Write-Output "							<input type=`"password`" class=`"form-control`" name=`"$FieldName`" id=`"$FieldName`" placeholder=`"$($Field.label)`" value=`"`" autofocus>`r`n"
			Write-Output "						</div>`r`n"
			Write-Output "					</div>`r`n"
		}

		if($Field.type -eq 'select')
		{
			Write-Output "				<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-$FieldName`">`r`n"
			Write-Output "					<label for=`"$FieldName`" class=`"col-sm-3 col-form-label font-weight-bold`">$($Field.label)</label>`r`n"
			Write-Output "					<div class=`"col-sm-9 pt-1`">`r`n"
			Write-Output "							<select name=`"$FieldName`" id=`"$FieldName`" class=`"form-control chosen-select`">`r`n"
			Write-Output "								<option selected></option>`r`n"
			foreach($Option in $Field.options)
			{
				Write-Output "								<option value=`"$($Option.value)`">$($Option.Option)</option>`r`n"
			}
			Write-Output "							</select>`r`n"
			Write-Output "					</div>`r`n"
			Write-Output "				</div>`r`n"
		}

		if($Field.type -eq 'checkbox')
		{
			Write-Output "					<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-$FieldName`">`r`n"
			Write-Output "						<div class=`"col-sm-3 font-weight-bold`">$($Field.label)</div>`r`n"
			Write-Output "							<div class=`"col-sm-9`">`r`n"
			Write-Output "								<div class=`"form-check`">`r`n"
			Write-Output "									<input class=`"form-check-input`" type=`"checkbox`" id=`"$FieldName`" name=`"$FieldName`">`r`n"
			Write-Output "									<label class=`"form-check-label`" for=`"$FieldName`"></label>`r`n"
			Write-Output "								</div>`r`n"
			Write-Output "							</div>`r`n"
			Write-Output "					</div>`r`n"
		}

		if($Field.type -eq 'radio')
		{

		}
	}

	if($PageData.CaseNumberRequired -eq $True)
	{
		Write-Output "					<div class=`"form-group row py-2 mx-0 border`" id=`"formgroup-casenumber`">`r`n"
		Write-Output "						<label for=`"casenumber`" class=`"col-sm-3 col-form-label font-weight-bold`">Case Number</label>`r`n"
		Write-Output "						<div class=`"col-sm-9`">`r`n"
		Write-Output "							<input type=`"text`" class=`"form-control`" name=`"casenumber`" id=`"casenumber`" placeholder=`"Case Number`" value=`"`" autofocus>`r`n"
		Write-Output "						</div>`r`n"
		Write-Output "					</div>`r`n"
	}

	Write-Output "					<div class=`"form-group row py-3 mx-0`">`r`n"
	Write-Output "						<div class=`"col-sm-12`">`r`n"
	Write-Output "							<button type=`"submit`" class=`"btn btn-primary`" name=`"submit`" id=`"submit`">$($PageData.SubmitButtonText)</button>`r`n"
	Write-Output "						</div>`r`n"
	Write-Output "					</div>`r`n"

	Write-Output '				</form>'
	# End container
	#Write-Output '</div>'
}

function BuildAccordian()
{
	Write-Output "				<div class=`"accordion`" id=`"accordionExample`">`r`n"
	Write-Output "					<div class=`"accordion-item`">`r`n"
	Write-Output "						<h2 class=`"accordion-header`" id=`"headingOne`">`r`n"
	Write-Output "							<button id=`"tasklistbutton`" class=`"accordion-button collapsed`" type=`"button`" data-bs-toggle=`"collapse`" data-bs-target=`"#collapseOne`" aria-expanded=`"false`" aria-controls=`"collapseOne`">`r`n"
	Write-Output "								...`r`n"
	Write-Output "							</button>`r`n"
	Write-Output "						</h2>`r`n"
	Write-Output "						<div id=`"tasklistbody`" class=`"accordion-collapse collapse`" aria-labelledby=`"headingOne`" data-bs-parent=`"#accordionExample`">`r`n"
	Write-Output "							<div class=`"accordion-body`">`r`n"
	Write-Output "								<div id='tasklistoutput'></div>`r`n"
	Write-Output "							</div>`r`n"
	Write-Output "						</div>`r`n"
	Write-Output "					</div>`r`n"
	Write-Output "					<div class=`"accordion-item`">`r`n"
	Write-Output "						<h2 class=`"accordion-header`" id=`"headingTwo`">`r`n"
	Write-Output "							<button id=`"outputbutton`" class=`"accordion-button collapsed`" type=`"button`" data-bs-toggle=`"collapse`" data-bs-target=`"#collapseTwo`" aria-expanded=`"false`" aria-controls=`"collapseTwo`">`r`n"
	Write-Output "							</button>`r`n"
	Write-Output "						</h2>`r`n"
	Write-Output "						<div id=`"outputbody`" class=`"accordion-collapse collapse`" aria-labelledby=`"headingTwo`" data-bs-parent=`"#accordionExample`">`r`n"
	Write-Output "							<div class=`"accordion-body`">`r`n"
	Write-Output "								<div id='output'></div>`r`n"
	Write-Output "							</div>`r`n"
	Write-Output "						</div>`r`n"
	Write-Output "					</div>`r`n"
	Write-Output "				</div>`r`n"
}