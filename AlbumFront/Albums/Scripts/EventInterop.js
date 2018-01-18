function InterEvent( e )
{
	this.ev = (e != null && typeof(e) != "undefined" ? e:window.event);

	if( typeof(this.ev.offsetX) != "undefined" )
	{
		this.cliX = this.ev.offsetX;
		this.cliY = this.ev.offsetY;
	}
	else //NN, Mozilla, FFx
	{
		this.cliX = this.ev.layerX;
		this.cliY = this.ev.layerY;
	}
	
	if( this.ev.pageX || this.ev.pageY )
	{
	    this.pageX = this.ev.pageX;
	    this.pageY = this.ev.pageY;
	}
	else
	{
	    this.pageX = this.ev.clientX + document.body.scrollLeft;
	    this.pageY = this.ev.clientY + document.body.scrollTop;
	}

	if( typeof(this.ev.target) != "undefined" )
		this.srcEl = this.ev.target;
	else if( typeof(this.ev.srcElement) != "undefined" )
		this.srcEl = this.ev.srcElement;
	if( this.srcEl.nodeType == 3 )
		this.srcEl = this.parentNode; //Safari bug

	this.code = (this.ev.keyCode ? this.ev.keyCode:this.ev.which); //keyboard
	this.button = (this.ev.button ? this.ev.button:this.ev.which);
	//this.srcEl = this.ev.srcElement;
	
	if( typeof(this.ev.shiftKey) != "undefined" )
		this.shiftKey = this.ev.shiftKey;
	else
		this.shiftKey = ((this.ev.modifiers & 4) == 4);
		
	if( typeof(this.ev.ctrlKey) != "undefined" )
		this.ctrlKey = this.ev.ctrlKey;
	else
		this.ctrlKey = ((this.ev.modifiers & 2) == 2);
}

InterEvent.prototype.cancelEvent = function()
{
	if( typeof(this.ev.returnValue) != "undefined" )
		this.ev.returnValue = false;
	if( typeof(this.ev.cancelBubble) != "undefined" )
		this.ev.cancelBubble = true;
		
	if( this.ev.stopPropagation ) this.ev.stopPropagation();

	return false;
}

function cancelContextMenu( e )
{
	var ev = new InterEvent( e );
	var name = ev.srcEl.tagName.toLowerCase();

	return name == "input" || name == "textarea";
}
function cancelSelect( e )
{
	var ev = new InterEvent( e );

	var name = ev.srcEl.tagName.toLowerCase();
	if( name != "input" && name != "textarea" )
		return ev.cancelEvent();
	else
		return true;
}

function disableContextMenuAndSelection( tagRef )
{
    tagRef.oncontextmenu = cancelContextMenu;
    tagRef.onselectstart  = cancelSelect;
}
