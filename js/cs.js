/* jshint browser:true */

/**
 * these functions are all specific to CloudSponge
 */

function toggleEmailEntry(divelem) {
    "use strict";
	if (divelem === 'divManualEntry') {
		document.getElementById('divManualEntry').style.display = 'block';
		document.getElementById('divImportEntry').style.display = 'none';
		document.getElementById('divAddrContentDtl').style.display = 'none';
		
	} else {
		var groupData = document.getElementById('groupData').value;
		document.getElementById('divManualEntry').style.display = 'none';
		document.getElementById('divImportEntry').style.display = 'block';
		if (groupData.length > 0) {
			document.getElementById('divAddrContentDtl').style.display = 'block';
		}
	}
}

/* global $:true */
function launchPopUp(service, strUrl) {
    "use strict";
    if (strUrl.length === 0) 
		return false;
	
	// check if previous import exist
	var groupData = document.getElementById('groupData').value;
		
	// if empty, then proceed
	if( /^\s*$/.test( groupData ) ){
		// show popup box
		$(function () {
			var $dialog = $('#popupWindow');
                $dialog.empty();
                $dialog.load(strUrl).dialog({
                    title:"Import from Address Book",
                    modal: true,
                    autoOpen: false,
                    width: 610,
                    height: 570,
                    show:'fade',
                    hide:'fade',
                    resizable: false
				});	
			$dialog.dialog( "option", "buttons", {
                "Import": function(){
                    importSelected($dialog);
                },
                "Close": function() { 
                    var importedData = window.parent.document.getElementById('groupData').value;
                    if( /^\s*$/.test( importedData ) ){
                        var $confExit = $("<div></div>");
                        $confExit.html("No records were imported. Close the window anyway?");
                        $confExit.dialog({
                            resizable: false,
                            modal: true,
                            title: "Confirmation",
                            autoOpen: false,
                            buttons: {
                                "Yes": function () {
                                    $confExit.dialog('close');
                                    $confExit.empty();
                                    // destroy any timeouts
                                    destroyTimeouts();
                                    // close the window
                                    $dialog.dialog("close");
                                    $(this).empty();
                                },
                                "No": function () {
                                    $confExit.dialog('close');
                                    $confExit.empty();
                                }
                            }
                        });
                        $confExit.dialog('open');
                    } 
                    else {
                        destroyTimeouts();
                        // close the window
                        $dialog.dialog("close");
                        $(this).empty();
                    } // end importedData
                } // end close button
            });
			
			// launch popup window
			$dialog.dialog('open');
			
		});
    }
	else {
		alertBox('Message','You can only import one address book type at a time.');
	}
		
}


function populateTextarea(contacts) {
	var contact;
	var tblRecords = document.getElementById('tblRecords');
	var lstgroupData = '';
	if( contacts.length > 0 ){
		document.getElementById('divAddrContentDtl').style.display = 'block'; // this element must exist in the page that the include is being used
		if( contacts.length > 10 ){
			document.getElementById('divRecords').style.height = '210px';
		}
	}
	
	// format each email address properly
	for (var i=0; i < contacts.length; i++) {
        contact = contacts[i];
        var row = tblRecords.insertRow(i+1);
        var emailCol = row.insertCell(0);
        var fnCol = row.insertCell(1);
        var lnCol = row.insertCell(2);

        // apply class
        emailCol.className = 'smallText smallText2';
        emailCol.style.wordWrap = "break-word";
        fnCol.className = 'smallText smallText2';
        fnCol.width = "30%";
        lnCol.className = 'smallText smallText2';
        lnCol.width = "30%";

        emailCol.innerHTML = contact.email;
        fnCol.innerHTML = contact.first_name;
        lnCol.innerHTML = contact.last_name;

        if( i == (contacts.length-1) )
        lstgroupData += contact.email + ',' + contact.first_name + ',' + contact.last_name;
        else
        lstgroupData += contact.email + ',' + contact.first_name + ',' + contact.last_name + '||';
	}
	// set form variable
	document.getElementById('groupData').value = lstgroupData;
	document.getElementById('importTotal').innerHTML = contacts.length;
  
	}
	
function checkAll(btnVal) {
	var cbElems = document.getElementsByTagName('input');
	for(var i=0; i < cbElems.length; i++) {
		if(cbElems[i].type == 'checkbox' && cbElems[i].name != 'groupalias') {
			cbElems[i].checked = btnVal == 'ALL' ? true : false;
		}
	}
	// change button value
	document.getElementById('btnChkUnchk').value = (btnVal == 'ALL') ? 'NONE' : 'ALL';
}
		
function importSelected(d){
	var contacts = [];
	var cbElems = document.getElementsByTagName('input');
    for(var i=1; i < cbElems.length; i++) {
        if(cbElems[i].type == 'checkbox' && cbElems[i].checked){
        var inputVal = cbElems[i].value;
        var jsonData = {};
        var record = '';
        if( inputVal.indexOf('||') > 0 ){
            record = (inputVal).split('||');
            jsonData.email = record[0];
            jsonData.first_name = record[1];
            jsonData.last_name = record[2];
            contacts.push(jsonData);
        }
        }
    }

    if( contacts.length === 0 ){
        alertBox('Message','You did not select any records to be imported.');
    } else {
        window.parent.populateTextarea(contacts);
        destroyTimeouts();
        d.dialog('close');
        d.empty();
    }
}

/* global $alertBox:true */
function alertBox(strTitle, strMessage){
	$( function() {
			$alertBox = $('<div></div>');
			$alertBox.html(strMessage);
			$alertBox.dialog({
                title       : strTitle,
                modal       : true,
                resizable   : false,
                autoOpen    : false
            });
		$alertBox.dialog( "option", "buttons", {
            "Ok": function() {
                $alertBox.dialog("close");
                $(this).empty();
            }
        });
        $alertBox.dialog('open');
	});
	
}

function standardPopup(url, width, height) {
    
	var lp, tp;
	lp = (window.screen.width / 2) - ((width / 2) + 10);
	tp = (window.screen.height / 2) - ((height / 2) + 50);
    //Open the window.
    window.open(url, "newpopup",
                "status=no,height=" + height + ",width=" + width + ",resizable=yes,left=" + lp + ",top=" + tp + ",screenX=" + lp + ",screenY=" + tp + ",toolbar=no,menubar=no,scrollbars=no,location=no,directories=no");
}

function destroyTimeouts(){
    var hackyTimeout = setTimeout(";");
    for (var i = 0; i < hackyTimeout; i++) { clearTimeout(i); }
}