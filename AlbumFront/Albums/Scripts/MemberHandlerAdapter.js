
var __gAdapters = new Array();

function addAdapter( obj )
{
    var i = 0;
    for( ; i < __gAdapters.length; ++i )
        if( __gAdapters[i] == null )
            break;

    var res;
    if( i < __gAdapters.length )
        __gAdapters[ i ] = obj, res = i;
    else
        __gAdapters.push( obj ), res = __gAdapters.length - 1;

    return res;
}
function removeAdapter( index )
{
    __gAdapters[ index ] = null;
}
function getAdapter( index )
{
    return __gAdapters[ index ];
}

function CMemberAdapter( ivokableObject, memberNameToInvoke, oldHandlerPtr )
{
    this.objRef = ivokableObject;
    this.memberName = memberNameToInvoke;
    this.index = addAdapter( this );
    this.oldHandlerPtr = oldHandlerPtr;

    var thunkCode;
    thunkCode = "var adapter = getAdapter(" + this.index.toString() + ");\r\n";
    thunkCode += "if( adapter == null ) return false;\r\n";
    thunkCode += "return adapter.invoke( arguments );\r\n";
    //thunkCode += "adapter.objRef." + this.memberName + "(arguments.length > 0 ? arguments[0]:null);";

    this.adapterThunk = new Function( thunkCode );
}
CMemberAdapter.prototype.destroy = function()
{
    this.objRef = null;
    removeAdapter( this.index );
}
CMemberAdapter.prototype.invoke = function( args )
{
    var arg;
    if (args && args.length > 0)
        arg = args[0];
    
    var res = eval("this.objRef." + this.memberName + "(typeof(arg) === 'undefined' ? window.event:arg);");

    if( res === true )
        return true;

    if( this.oldHandlerPtr != null )
        return this.oldHandlerPtr( arg );

    return false;
}

/*function setMemberAsEventHandler( htmlTagObj, eventName, ivokableObject, memberNameToInvoke )
{
    var oldPtr = null;
    if( htmlTagObj == null ) return;
    if( typeof(htmlTagObj[eventName]) != "undefined" )
        oldPtr = htmlTagObj[ eventName ];
    htmlTagObj[ eventName ] = new CMemberAdapter( ivokableObject, memberNameToInvoke, oldPtr ).adapterThunk;
    return htmlTagObj[ eventName ];
}*/

function MemberHandlerData( htmlTagObj, eventName, ivokableObject, memberNameToInvoke )
{
    this._htmlTagObj = htmlTagObj;
    this._eventName = eventName;
    this._old_ptr = null;
    this._handler_ptr = null;

    if( htmlTagObj == null ) return;
    if( typeof(htmlTagObj[eventName]) != "undefined" )
        this._old_ptr = htmlTagObj[ eventName ];

    this._handler_ptr = new CMemberAdapter( ivokableObject, memberNameToInvoke, this._old_ptr ).adapterThunk;
    htmlTagObj[ eventName ] = this._handler_ptr;
}

MemberHandlerData.prototype.destroy = function()
{
    if( this._old_ptr != null )
    {
        this._htmlTagObj[ this._eventName ] = this._old_ptr;
        this._old_ptr = null;
        this._handler_ptr = null;
    }
}
