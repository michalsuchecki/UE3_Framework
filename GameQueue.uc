class GameQueue extends Object;

var array<GameClientRequestInfo> Elements;
var int Count;

function Put(GameClientRequestInfo Item)
{
    local GameClientRequestInfo NewItem;

    NewItem = new class'GameClientRequestInfo' (Item);
    Elements.AddItem(NewItem);
}

function PutFront(GameClientRequestInfo Item)
{
    local GameClientRequestInfo NewItem;

    NewItem = new class'GameClientRequestInfo' (Item);
    Elements.InsertItem(0, NewItem);
}

function Put2(string URL)
{
    local GameClientRequestInfo elem;

    elem = new class'GameClientRequestInfo';
    elem.URL = URL;
    Elements.AddItem(elem);
}

function GameClientRequestInfo Get()
{
    local GameClientRequestInfo Result;

    if(Empty())
    {
        return Result;
    }

    Result = Elements[0];
    Elements.Remove(0, 1);
    return Result;
}

function bool Empty()
{
    return Elements.Length == 0;
}
