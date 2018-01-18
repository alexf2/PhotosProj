function Master( ctlTagObjID, ctlControlledContainerID)
{
    this._ID = ctlTagObjID;
    this._ctlControlledContainerID = ctlControlledContainerID;
    //this._ctlFakeContainer = ctlFakeContainer;
    //this._colCtlId = colCtlId;
    
    this.submit_old = null;
    this.onsubmit_old = null;
    this.submitHandlerPtr = null;

    this.scx = this.scy = null;
    this.scw = this.sch = null;

    this.eventHandlers = new Array();
}

Master.prototype.hookEvent = function( htmlTagObj, eventName, ivokableObject, memberNameToInvoke )
{
    var mhd = new MemberHandlerData( htmlTagObj, eventName, ivokableObject, memberNameToInvoke );
    this.eventHandlers.push( mhd );
    return mhd;
}
Master.prototype.handsoff = function()
{
    if( this.eventHandlers != null )
        for( var i = 0; i < this.eventHandlers.length; ++i )
            this.eventHandlers[ i ].destroy();
    this.eventHandlers = new Array();    
}

Master.prototype.objRef = function()
{
    return document.getElementById( this._ID );
}

Master.prototype.init = function()
{
    var ctlTag = this.objRef();
    
    ctlTag.awsFrameMapRuntime.isNavTreeShown = (ctlTag.awsFrameMapRuntime.isNavTreeShown == "true" ? true:false);
    updateHidden( ctlTag.awsFrameMapRuntime.hiddenIsNavTreeShown, ctlTag.awsFrameMapRuntime.isNavTreeShown );
    
    //this.applyNavTreeState();

    
    //alert( ctlTag.awsFrameMap.btnHideTree );
    var btnSwitchFrame = document.getElementById( ctlTag.awsFrameMap.btnHideTree );
    this.hookEvent(btnSwitchFrame, "onclick", this, "onShowHideNavTree");
    this.hookEvent(document, "onkeyup", this, "onKeyPress");
 
    //Scroll tree
    /*var msHidden = document.getElementById( ctlTag.awsFrameMapRuntime.apsNet_TreeViewSelNodeInputID );
    if( msHidden != null )
    {
        var selNode = document.getElementById( msHidden.value );
        if( selNode != null )
        {
            selNode.scrollIntoView( true );
            //document.getElementById( ctlTag.awsFrameMapRuntime.treeContainerID ).scrollLeft = 0;
        }
    }*/
    
    this.scx = parseInt( document.getElementById(ctlTag.awsFrameMapRuntime.hiddenScx).value );
    this.scy = parseInt( document.getElementById(ctlTag.awsFrameMapRuntime.hiddenScy).value );
    
    this.scw = parseInt( document.getElementById(ctlTag.awsFrameMapRuntime.hiddenScw).value );
    this.sch = parseInt( document.getElementById(ctlTag.awsFrameMapRuntime.hiddenSch).value );
    
    this.applyScroll();
    
    //alert( ctlTag.awsFrameMapRuntime.formID );
    var f = document.getElementById( ctlTag.awsFrameMapRuntime.formID );
    //var f = document.forms[ 0 ];
    this.submit_old = f.submit;
    f.submit = new CMemberAdapter( this, "preSubmit" ).adapterThunk;
    
    this.submitHandlerPtr = new CMemberAdapter( this, "onPreSubmit" ).adapterThunk;
    /*if( f.attachEvent )
        f.attachEvent( "onsubmit", this.submitHandlerPtr );
    else if( f.addEventListener )
        f.addEventListener( "submit", this.submitHandlerPtr, false );        
    else
    {
        this.onsubmit_old = f.onsubmit;
        f.onsubmit = this.submitHandlerPtr;            
    } */  
    this.onsubmit_old = f.onsubmit;
    f.onsubmit = this.submitHandlerPtr;
}

Master.prototype.preSubmit = function()
{
//alert( "Frame.prototype.preSubmit" );
//debugger;
    try
    {
        this.alterVieweState();
    }
    catch(e)
    {
    }
//alert(  typeof(this.submit_old) );    
    if( this.submit_old != null && typeof(this.submit_old) != "undefined" )
    {
        var ctlTag = this.objRef();
        var f = document.getElementById( ctlTag.awsFrameMapRuntime.formID );

        f.submit = this.submit_old;
        return f.submit();
        //return this.submit_old();

        //this.submit_old.apply( document.forms[0] );
    }
        //eval( this.submit_old );
    return true;
}
Master.prototype.onPreSubmit = function()
{
//alert( "Frame.prototype.onPreSubmit" );
    try {    
        this.alterVieweState();
    }
    catch( e )
    {
    }
    if( this.onsubmit_old != null && typeof(this.onsubmit_old) != "undefined" )
    {
        var ctlTag = this.objRef();
        var f = document.getElementById( ctlTag.awsFrameMapRuntime.formID );
        
        f.onsubmit = this.onsubmit_old;
        return f.onsubmit();
        //return this.onsubmit_old();
    }
    return true;
}

Master.prototype.alterVieweState = function()
{
    var ctlTag = this.objRef();
    this.readScroll();
    document.getElementById(ctlTag.awsFrameMapRuntime.hiddenScx).value = this.scx.toString();
    document.getElementById(ctlTag.awsFrameMapRuntime.hiddenScy).value = this.scy.toString();

    document.getElementById(ctlTag.awsFrameMapRuntime.hiddenScw).value = this.scw.toString();
    document.getElementById(ctlTag.awsFrameMapRuntime.hiddenSch).value = this.sch.toString();    
}


Master.prototype.applyScroll = function()
{
    var ctlTag = this.objRef();
    var cont = document.getElementById( ctlTag.awsFrameMapRuntime.treeContId );
    
    //if( cont.scrollWidth > this.scw )
        this.scx = this.correctScroll( this.scx, this.scw, cont.scrollWidth, cont.clientWidth );
    cont.scrollLeft = this.scx;
    //this.scy += cont.offsetHeight;

    //if( cont.scrollHeight > this.sch )
        this.scy = this.correctScroll( this.scy, this.sch, cont.scrollHeight, cont.clientHeight );
        
    cont.scrollTop = this.scy;
    
    //alert( this.sch + " - " + cont.scrollHeight );
            
    //alert( "Apply: " + this.scx + "; " + this.scy + "; offsh: " + cont.offsetHeight );
}
Master.prototype.correctScroll = function( scVal, scSizeOld, scSizeNew, sz )
{
    var res;
    if( scSizeOld == 0 || scSizeNew == 0 )
        res = scVal;
    else
    {    
        //res = Math.round( scVal * scSizeNew / scSizeOld );
        res = Math.min( scVal, scSizeNew - sz );        
    }
    return res;
}
Master.prototype.readScroll = function()
{
    var ctlTag = this.objRef();
    var cont = document.getElementById( ctlTag.awsFrameMapRuntime.treeContId );
    this.scx = cont.scrollLeft;
    this.scy = cont.scrollTop;
//alert( this.scy );    
    this.scw = cont.scrollWidth;

    this.sch = cont.scrollHeight;
//alert( typeof(cont.scrollHeight) );        
    
    //alert( "Read = " + this.scx + "; " + this.scy );
}

Master.prototype.onKeyPress = function (ev) {
    var ctlTag = this.objRef();

    var btn;    
    var key = ev.keyCode || ev.charCode;

    var hasLisghboxVisible = function () {        
        return jQuery(".jquery-lightbox-overlay").is(':visible');
    }

    if (key == 37 && !hasLisghboxVisible())
        btn = document.getElementById(ctlTag.awsFrameMap.btnPrev);
    else if (key == 39 && !hasLisghboxVisible())
        btn = document.getElementById(ctlTag.awsFrameMap.btnNext);
    
    if (btn && btn.disabled == false) {                
        btn.click();        
    }
    return false;
}

Master.prototype.onShowHideNavTree = function()
{
    var ctlTag = this.objRef();    
    
    ctlTag.awsFrameMapRuntime.isNavTreeShown = !ctlTag.awsFrameMapRuntime.isNavTreeShown;
    updateHidden( ctlTag.awsFrameMapRuntime.hiddenIsNavTreeShown, ctlTag.awsFrameMapRuntime.isNavTreeShown );
    //alert( ctlTag.awsFrameMapRuntime.isNavTreeShown );    
    
    this.applyNavTreeState();
}

Master.prototype.applyNavTreeState = function () {
	var ctlTag = this.objRef();

	var subj = document.getElementById(this._ctlControlledContainerID);

	//var subj2 = document.getElementById(this._ctlFakeContainer);	
	//var col1 = document.getElementById(this._colCtlId);
	
	if (ctlTag.awsFrameMapRuntime.isNavTreeShown == false) {
		
		subj.style.display = "none";
		subj.style.visibility = "hidden";

		/*subj2.style.display = "none";
		subj2.style.visibility = "hidden";
		
		col1.width = "1px";*/
	}
	else {
		
		subj.style.display = "block";
		subj.style.visibility = "visible";

		/*subj2.style.display = "block";
		subj2.style.visibility = "visible";
		
		col1.width = "20%";*/
	}
}
