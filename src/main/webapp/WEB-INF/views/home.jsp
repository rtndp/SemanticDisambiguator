<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<title>Home</title>
</head>
<body>
	<div id="header">
		<%@include file="header.jsp"%>
	</div>

	<div id="outer">
		<div id="title">
			<h1>
				<b>&lt;semantic disambiguator&gt;</b>
			</h1>
			<!-- <h6>&lt;alpha&gt;</h6> -->
		</div>

		<div id="knowledgeBase" data-toggle="buttons-radio">
			Select a knowledge base
			<button id="btn-one" type="button" data-toggle="button" name="option"
				value="1" class="btn btn-link">DBpedia</button>
			<button id="btn-two" type="button" data-toggle="button" name="option"
				value="2" class="btn btn-link">Yago</button>
			<button id="btn-two" type="button" data-toggle="button" name="option"
				value="3" class="btn btn-link">All</button>
		</div>
	</div>

	<div id="upload" class="input-group">
		<span class="input-group-btn"> <span
			class="btn btn-primary btn-file"> Browse <input
				id="uploadXMLFile" type="file">
		</span>
		</span> <input type="text" class="form-control" onchange="upload()"
			placeholder="Browse and upload a file [.xml] to preview, edit and process"
			readonly>
	</div>
	<div id="table-div">
		<!-- Div to hold the table description -->
		<!-- <div class="input-group">
			<input type="text" class="form-control"
				placeholder="Describe the table!"> <span
				class="input-group-btn">
				<button class="btn btn-default" type="button">Submit</button>
			</span>
		</div> -->
		<table id="table" class="table table-bordered table-hover">
		</table>
		<div id="buttons-div">
			<button type="button" class="btn btn-primary btn-lg"
				onclick="fetchXML();">Disambiguate</button>
			<!--DO THIS to call a controller on button click -  onclick="location.href='/umbc/test'" -->
		</div>
	</div>

	<!-- <div class="well">
		<a id="preview" href="#" rel="popover"><span
			class="glyphicon glyphicon-link"></span> </a>

	</div> -->

	<div id="footer">
		<%@include file="footer.jsp"%>
	</div>

	<!-- <div id="table-div">
		<table id="table" class="table table-bordered table-hover">

				<tr id="2">
					<td><input type="checkbox"></td>
					
					<td class="popover-markup"><a href="#" class="trigger">Eve</a>
						<div class="head hide">Description</div>
						<div class="content hide">
							<div class="form-group">
								<input type="text" class="form-control"
									placeholder="Cell Description"></input>
							</div>
							<button type="submit" class="btn btn-default btn-block">Save</button>
						</div></td>
				</tr>
		</table>
	</div> -->


</body>
<link type="text/css" rel="stylesheet" href="resources/css/style.css">
<link type="text/css" rel="stylesheet"
	href="resources/css/bootstrap.css">
<link type="text/css" rel="stylesheet"
	href="resources/css/bootstrap-theme.css">

<script type="text/javascript" src="resources/js/jquery-1.11.0.js"></script>
<script type="text/javascript" src="resources/js/bootstrap.js"></script>

<!-- FETCH THE XML OUTPUT FROM THE SERVER and DISPLAY -->
<script type="text/javascript">
	function fetchXML() {
		var noOfColumns = 0;

		var mygetrequest = new XMLHttpRequest();
		if (mygetrequest.overrideMimeType)
			mygetrequest.overrideMimeType('text/xml');
		mygetrequest.onreadystatechange = function() {
			if (mygetrequest.readyState == 4) {
				if (mygetrequest.status == 200
						|| window.location.href.indexOf("http") == -1) {
					//retrieve result as an XML object
					var xmlDoc = mygetrequest.responseXML;

					//Currently implemented for DBpedia only
					var ColumnHeadersDBpedia = xmlDoc
							.getElementsByTagName("colHeaderDBpCandidates");

					/*Clear the previous table from the <div>*/
					document.getElementById("table").innerHTML = "";

					var table = document.getElementById("table");
					var row = table.insertRow(-1);
					row.className = "header";

					/* var cell = row.insertCell(-1);
					cell.innerHTML = "<input type=\"checkbox\"></td>"; */
					
					/*************************COLUMN HEADERS******************/
					for ( var i = 0; i < ColumnHeadersDBpedia.length; i++) {
						var regexForMultipleSpaces = /\s+/;
						var headerCandidateList = ColumnHeadersDBpedia[i].childNodes[0].nodeValue
								.split(regexForMultipleSpaces);

						var cell = row.insertCell(-1);
						cell.className = 'col-xs-3';

						var select = document.createElement('select');
						select.className = "form-control";
						select.setAttribute('id', 'SelectColumnHeader' + i);

						var group = document.createElement('optgroup');
						group.setAttribute('label',
								'Possible DBpedia candidates');
						select.appendChild(group);
						for ( var a = 0; a < headerCandidateList.length; a++) {
							var option = document.createElement('option');
							var text = document
									.createTextNode(headerCandidateList[a]);

							option
									.setAttribute('value',
											headerCandidateList[a]);

							option.appendChild(text);
							group.appendChild(option);

						}
						cell.appendChild(select);

						var a = document.createElement('a');
						a.setAttribute('href', '#');
						a.setAttribute('id', 'ColumnHeader' + i);
						a.setAttribute('class', 'preview');
						a.setAttribute('rel', 'popover');

						a.setAttribute('data-original-title', '');
						a.setAttribute('title', '');

						$('.preview')
								.popover(
										{
											/*TODO: Need to create a function here to 
											fetch the title from the select */
											title : function() {
												var element = document
														.getElementById("Select"
																+ this.id);

												var selectValue = element.options[element.selectedIndex].value;

												return selectValue;
											},

											/*TODO: content is fetched from DBpedia 
											webservice by making a SPARQL query*/
											content : "Sachin Ramesh Tendulkar (born 24 April 1973) is an Indian cricketer widely considered to be one of the greatest batsmen of all time. He is the leading run-scorer and century maker in Test and one-day international cricket. He is the first player to score a double century in ODI cricket.",
											trigger : "click",
											placement : "auto"
										});

						var span = document.createElement('span');
						span.setAttribute('class', 'glyphicon glyphicon-link');

						a.appendChild(span);
						cell.appendChild(a);

						/* cell.innerHTML = ColumnHeadersDBpedia[i].childNodes[0].nodeValue; */
					}

					/*No of columns in the output*/
					noOfColumns = ColumnHeadersDBpedia.length;

					/*****************ROWS*******************/
					/*Fetch all the cell values for each row*/
					var cellAnnotations = xmlDoc
							.getElementsByTagName("candidates");

					/*Insert the first row*/
					var row = table.insertRow(-1);
					row.className = "testOutputRow";

					/* Insert the first cell in the firstrow */
					/* var cell = row.insertCell(-1);
					cell.innerHTML = "<input type=\"checkbox\"></td>"; 
					cell.className = "col-xs-2";*/

					var count = 0;

					/*Loop thru the list of all the candidates and populate all the appropriate cells*/

					for ( var i = 0; i < cellAnnotations.length; i++) {

						/*This is done to split the huge ass space seperated list into an array, 
						which is used in creating dropdowns*/
						var regexForMultipleSpaces = /\s+/;
						var candidateList = cellAnnotations[i].childNodes[0].nodeValue
								.split(regexForMultipleSpaces);
						/*Keep track of the row*/
						if (count == noOfColumns) {
							var row = table.insertRow(-1);
							row.className = "testOutputRow";

							/* var cell = row.insertCell(-1);
							cell.className = "col-xs-2";
							cell.innerHTML = "<input type=\"checkbox\"></td>"; */

							var cell = row.insertCell(-1);

							cell.className = "col-xs-3";
							var select = document.createElement('select');
							select.className = "form-control";
							select.setAttribute('id', 'SelectCell' + i);
							var group = document.createElement('optgroup');
							group.setAttribute('label', 'Possible candidates');
							select.appendChild(group);

							for ( var j = 0; j < candidateList.length; j++) {
								var option = document.createElement('option');
								var text = document
										.createTextNode(candidateList[j]);
								option.setAttribute('value', candidateList[j]);
								option.appendChild(text);
								group.appendChild(option);

							}
							cell.appendChild(select);
							var a = document.createElement('a');
							a.setAttribute('href', '#');
							a.setAttribute('id', 'Cell' + i);
							//Popover to display a short discription about the entity
							a.setAttribute('class', 'preview');
							a.setAttribute('rel', 'popover');

							/*TODO: Check if the popover works without these two attributes*/
							a.setAttribute('data-original-title', '');
							a.setAttribute('title', '');

							$('.preview')
									.popover(
											{
												title : function() {
													var element = document
															.getElementById("Select"
																	+ this.id);

													var selectValue = element.options[element.selectedIndex].value;

													return selectValue;
												},

												/*TODO: content is fetched from DBpedia 
												webservice by making a SPARQL query
												"Sachin Ramesh Tendulkar (born 24 April 1973) is an Indian cricketer widely considered to be one of the greatest batsmen of all time. 
												He is the leading run-scorer and century maker in Test and one-day international cricket. 
												He is the first player to score a double century in ODI cricket.",*/
												content : function() {
													var result;
													var element = document
															.getElementById("Select"
																	+ this.id);

													var entity = element.options[element.selectedIndex].value;

													var endPoint = "http://dbpedia.org/sparql";

													var query = [
															"PREFIX dbpedia2: <http://dbpedia.org/resource/>",
															" PREFIX Abs: <http://dbpedia.org/ontology/>",
															" SELECT (Str(?C) as ?comment)",
															" WHERE {<http://dbpedia.org/resource/",
															entity,
															">", /*Remeber to remove the > to get the query to work*/
															" rdfs:comment?C",
															" FILTER (lang(?C) =",
															"\"en\")}" ]
															.join("");
													alert(query);

													function myCallBack(str) {
														
														//alert(jsonObject.results.bindings[0].comment.value);
														//return jsonObject.results.bindings[0].comment.value;
													} 

													/* alert(result);
													return result; */
													sparqlQuery(query,
															endPoint, true);
												},
												trigger : "click",
												placement : "auto"
											});

							var span = document.createElement('span');
							span.setAttribute('class',
									'glyphicon glyphicon-link');

							a.appendChild(span);
							cell.appendChild(a);

							/*Reseting the value of count*/
							count = 0;
						} else {
							var cell = row.insertCell(-1);
							cell.className = 'col-xs-3';
							var select = document.createElement('select');
							select.className = "form-control";
							select.setAttribute('id', 'SelectCell' + i);
							var group = document.createElement('optgroup');
							group.setAttribute('label', 'Possible candidates');
							select.appendChild(group);

							for ( var k = 0; k < candidateList.length; k++) {
								var option = document.createElement('option');

								//TODO: This bit doesn't work, I cannot put a href inside an dropdown
								/* var a = document.createElement('a');
								a.setAttribute('href', '#');
								option.appendChild(a); */

								var text = document
										.createTextNode(candidateList[k]);
								option.setAttribute('value', candidateList[k]);
								option.appendChild(text);

								group.appendChild(option);

							}
							cell.appendChild(select);

							var a = document.createElement('a');
							a.setAttribute('href', '#');
							a.setAttribute('class', 'preview');
							a.setAttribute('id', 'Cell' + i);
							a.setAttribute('rel', 'popover');
							a.setAttribute('data-original-title', '');
							a.setAttribute('title', '');

							$('.preview')
									.popover(
											{
												/*TODO: title needs to be fetched from the value in the drop down*/
												title : function() {
													var element = document
															.getElementById("Select"
																	+ this.id);

													var selectValue = element.options[element.selectedIndex].value;

													return selectValue;
												},

												/*TODO: content is fetched from DBpedia 
												webservice by making a SPARQL query*/
												content : "Sachin Ramesh Tendulkar (born 24 April 1973) is an Indian cricketer widely considered to be one of the greatest batsmen of all time. He is the leading run-scorer and century maker in Test and one-day international cricket. He is the first player to score a double century in ODI cricket.",
												trigger : "hover",
												placement : "auto"
											});

							var span = document.createElement('span');
							span.setAttribute('class',
									'glyphicon glyphicon-link');

							a.appendChild(span);
							cell.appendChild(a);

						}
						count++;
					}
				} else {
					alert("An error has occured making the request");
				}
			}
		};

		mygetrequest.open("GET",
				"http://localhost:8080/umbc/resources/myAnnotation.xml", true);
		mygetrequest.send();
	}
</script>

<script type="text/javascript">
	$(".table td").click(function() {
		var text = $(this).text();
		alert(text);
	});
</script>

<!-- This function needs to be revisited -->
<!--  This function is written to load the XML from the users machine. INPUT-->
<script type="text/javascript">
	$(document)
			.on(
					'change',
					'.btn-file :file',
					function() {
						var noOfColumns = 0;
						var file = document.getElementById("uploadXMLFile").files[0];
						var reader = new FileReader();
						reader.readAsText(file);

						reader.onloadend = function(event) {

							/* alert("File Name - " + file.name + "\nFile Size - "
									+ file.size + "Bytes" + "\nFile Type - "
									+ file.type); */

							var xmlData = reader.result;
							/* alert(xmlData); */

							if (window.DOMParser) {
								parser = new DOMParser();
								xml = parser.parseFromString(xmlData,
										"text/xml");
							} else {
								xml = new ActiveXObject("Microsoft.XMLDOM");
								xml.async = false;
								xml.loadXML(xmlData);
							}
							/*Count the number of columns, this is required while accesing the rows and populating the table*/

							/*XPath to fetch the column headers*/
							path = "entity/logicalTable/content/header/cell/text";
							if (window.ActiveXObject) {
								xml.setProperty("SelectionLanguage", "XPath");
								nodes = xml.selectNodes(path);
								for ( var i = 0; i < nodes.length; i++) {
									document
											.write(nodes[i].childNodes[0].nodeValue);
									document.write("<br>");
								}
							}

							// code for Chrome, Firefox, Opera, etc.
							else if (document.implementation
									&& document.implementation.createDocument) {
								/*Count the number of columns, this is required while 
									accesing the rows and populating the table*/
								noOfColumns = xml
										.evaluate(
												'count(entity/logicalTable/content/header/cell/text)',
												xml, null,
												XPathResult.ANY_TYPE, null);
								/* alert(noOfColumns.numberValue); */

								var nodes = xml.evaluate(path, xml, null,
										XPathResult.ANY_TYPE, null);

								var result = nodes.iterateNext();
								var count = 1;
								/*Clear any previous tables*/
								document.getElementById("table").innerHTML = "";
								var table = document.getElementById("table");
								//var header = table.createTHead();
								var row = table.insertRow(-1);
								row.className = "test";
								var cell = row.insertCell(-1);
								cell.innerHTML = "<input type=\"checkbox\"></td>";
								while (result) {

									var cell = row.insertCell(-1);
									cell.innerHTML = result.childNodes[0].nodeValue;

									if (count == noOfColumns.numberValue) {
										count = 1;
									}
									count++;
									result = nodes.iterateNext();
								}

							}

							path = "entity/logicalTable/content/row/cell/text";
							if (window.ActiveXObject) {
								xml.setProperty("SelectionLanguage", "XPath");
								nodes = xml.selectNodes(path);
								for ( var i = 0; i < nodes.length; i++) {
									document
											.createTextNode(nodes[i].childNodes[0].nodeValue);
									document.createTextNode("<br>");
								}
							}

							// code for Chrome, Firefox, Opera, etc.
							/*The while loop needs to be rewritten in a better way, 
							by creating elements and appending them to their parents*/
							else if (document.implementation
									&& document.implementation.createDocument) {
								var nodes = xml.evaluate(path, xml, null,
										XPathResult.ANY_TYPE, null);
								var result = nodes.iterateNext();

								count = 1;

								while (result) {
									if (count == 1) {
										row = table.insertRow(-1);
										var cell = row.insertCell(-1);
										cell.innerHTML = "<input type=\"checkbox\"></td>";
									}
									row.className = "popover-markup";
									var cell = row.insertCell(-1);
									cell.innerHTML = "<a href=\"#\" class=\"trigger\">"
											+ result.childNodes[0].nodeValue
											+ "</a>";

									if (count == noOfColumns.numberValue) {
										count = 0;
									}
									count++;
									result = nodes.iterateNext();
								}
							}
							var button = document.getElementById("buttons-div");
							button.style.display = 'block';

							var outer = document.getElementById("outer");
							outer.style.display = 'none';
						};

						reader.onerror = function(event) {
							alert("onError Event Triggered");
							var error = event.target.error;
							alert(error);
						};
					});
</script>

<!-- This is script is written to query DBpedia and fetch the required comments about an entity -->
<script type="text/javascript">
	function sparqlQuery(queryStr, endPoint, isDebug) {

		var queryPart = "query=" + escape(queryStr);

		var xmlhttp = null;
		if (window.XMLHttpRequest) {
			xmlhttp = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			// Code for older versions of IE, like IE6 and before.
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		} else {
			alert('Perhaps your browser does not support XMLHttpRequests?');
		}

		// GET can have caching probs, so POST
		xmlhttp.open('POST', endPoint, true);
		xmlhttp.setRequestHeader('Content-type',
				'application/x-www-form-urlencoded');
		xmlhttp.setRequestHeader("Accept", "application/sparql-results+json");

		// Set up callback to get the response asynchronously.
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status == 200) {
					// Do something with the results
					if (isDebug) {
						alert(xmlhttp.responseText);
						callback(xmlhttp.responseText);
						/* alert(returnVal);
						var jsonObject = JSON.parse(xmlhttp.responseText); */
						jsonObject.results.bindings[0].comment.value;
					} else {
						// Some kind of error occurred.
						alert("Sparql query error: " + xmlhttp.status + " "
								+ xmlhttp.responseText);
					}
				}
			};
			//Send the query to the endpoint.
		};
		xmlhttp.send(queryPart);
	}
</script>
</html>
