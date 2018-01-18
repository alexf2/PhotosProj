
function formatFloat2( v )
{
	return (Math.round( v * 100.0 ) / 100.0).toString( 10 );
}

function perc( val, p )
{
	return val / 100.0 * p;
}

function navigateTo( relURL )
{
	if( window.navigate )
		window.navigate( relURL );
	else if( location && location.assign )
		location.assign( relURL );
	else
	{
		var idxSl = location.pathname.lastIndexOf( "/" );
		if( idxSl == - 1 )
			location.pathname = relURL;
		else
			location.pathname = location.pathname.substr(0, idxSl + 1) + relURL;
	}	
}

function backTo()
{
	/*if( history.back )
		history.back();
	else*/
	history.go( -1 );
}

function getClientLeft( elem )
{
	var dx = 0, tagN;
	do
	{
		tagN = elem.tagName.toLowerCase();
		dx += elem.offsetLeft;
		if( typeof(elem.clientLeft) != "undefined" && tagN != "table" && tagN != "body" )
			dx +=  elem.clientLeft;

	} while( (elem = elem.offsetParent) != null );

	return dx;
}
function getClientTop( elem )
{
	var dy = 0, tagN;

	do
	{
		tagN = elem.tagName.toLowerCase();
		dy += elem.offsetTop;

		if( typeof(elem.clientTop) != "undefined" && tagN != "table" && tagN != "body" )
			dy +=  elem.clientTop;

	} while( (elem = elem.offsetParent) != null );

	return dy;
}

function findPosX( obj )
{
	var curleft = 0;
	if( obj.offsetParent )
	{
		while( obj.offsetParent )
		{
			curleft += obj.offsetLeft;
			obj = obj.offsetParent;
		}
	}
	else if( obj.x )
		curleft += obj.x;
	return curleft;
}

function findPosY( obj )
{
	var curtop = 0;
	if( obj.offsetParent )
	{
		while( obj.offsetParent )
		{
			curtop += obj.offsetTop;
			obj = obj.offsetParent;
		}
	}
	else if( obj.y )
		curtop += obj.y;
	return curtop;
}

function replaceVals( str, arr )
{
	var res = str;
	for( var i = 0; i < arr.length; i+=2 )
		res = res.replace( arr[i], arr[i + 1] );
	return res;
}

function getChildElementById( parent, tagName, id )
{
	var res = null;
	var els = parent.getElementsByTagName( tagName );
	for( var i = 0; i < els.length; ++i )
	{
		var sp = els[ i ];
		if( sp.getAttribute("id", 0) == id )
		{
			res = sp;
			break;
		}
	}
	return res;
}

function hookEventZero( obj, name, handler )
{
    /*if( obj.attachEvent )
        obj.attachEvent( name, handler );
    else if( obj.addEventListener )
        obj.addEventListener( name, handler, false );
    else*/
        obj[ name ] = handler;
        
        /*if( typeof(targetObj) != "undefined" )
            obj[ attrName ] = targetObj;*/
}

function updateHidden( name, val )
{
	var hdf = document.getElementsByName( name )[ 0 ];
	hdf.value = val.toString();
}
function getHiddenStr( name )
{
	var hdf = document.getElementsByName( name )[ 0 ];
	return hdf.value;
}
function getHiddenNum( name )
{
	var hdf = document.getElementsByName( name )[ 0 ];
	return parseFloat( hdf.value );
}
function getHiddenInt( name )
{
	var hdf = document.getElementsByName( name )[ 0 ];
	return parseInt( hdf.value, 10 );
}

function safeGet( v )
{
    return v == 0 ? 1:v;
}

function pointInRect( el, x, y )//x, y - are local
{
    //alert( el.clientWidth.toString() + "; " + el.clientHeight.toString() );
    return x >= 0 && x < el.clientWidth && y >= 0 && y < el.clientHeight;
}
