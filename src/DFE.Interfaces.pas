unit DFE.Interfaces;

interface
uses
  System.Generics.Collections,
  DFE.Maybe;

Type
  ICloneable<T> =  interface['{850DCD71-2475-4422-AE95-844ADD539CD6}']
    Function Clone( Target : T) : Boolean;
  end;

  TForEachFunction<ItemType> = reference to procedure(item : ItemType);
  TMapFunction<ItemType> = reference to function(item : ItemType) : Maybe<ItemType>;
  TFilterFunction<ItemType> = reference to function(item : ItemType) : Boolean ;


  IIterator<ItemType> = interface['{0ABF1B5B-A2DA-4A62-9BCC-B5581CA02B9A}']
    function  Next(): Maybe<ItemType>;
    function  First(): Maybe<ItemType>;
    function  Last(): Maybe<ItemType>;
    Function  Count() : integer;
    Function  Current : Maybe<ItemType>;
    procedure Reset();
    Function  Items : Tlist<ItemType>;
    function  GetItem(index : integer): Maybe<ItemType>;
    Function  Delete(Index : Integer) : Boolean;
    Procedure Add(item : ItemType);
    Function  IsEmpty : Boolean;
    Function  IsNotEmpty : Boolean;

    function  ForEach(proc : TForEachFunction<ItemType>) : IIterator<ItemType>;
    function  Map(func : TMapFunction<ItemType>) : IIterator<ItemType>;
    function  Filter(func : TFilterFunction<ItemType>) : IIterator<ItemType>;
  end;
implementation

end.
