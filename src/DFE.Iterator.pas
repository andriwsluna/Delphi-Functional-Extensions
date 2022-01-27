unit DFE.Iterator;

interface

uses
  System.Generics.Collections,
  DFE.Maybe,
  DFE.Interfaces;

Type
  TIterator<ItemType :  IInterface ; SelfType : IIterator<ItemType>> =
  class(TinterfacedObject, IIterator<ItemType>)

  private
    Procedure ProcessForEach(proc : TForEachFunction<ItemType> ; iter : TIterator<ItemType , SelfType>);
    Procedure ProcessMap(func : TMapFunction<ItemType> ; iter : TIterator<ItemType , SelfType>);
    Procedure ProcessFilter(func : TFilterFunction<ItemType> ; iter : TIterator<ItemType , SelfType>);
  protected
    FIndex : integer;
    FItems : Tlist<ItemType>;


    Procedure Initialize(); Virtual;
    Procedure Finalize(); Virtual;
    Function  NewIteratorConstructor : SelfType; Virtual;

  public
    Constructor Create(); Reintroduce; Virtual;
    Destructor  Destroy(); Override;
  public
    Function  IsEmpty : Boolean; Virtual;
    Function  IsNotEmpty : Boolean; Virtual;

    Function  Count() : integer; Virtual;
    Function  Current : Maybe<ItemType>; Virtual;

    Function Delete(Index : Integer) : Boolean;
    Procedure Add(item : ItemType);

    function  Next(): Maybe<ItemType>; Virtual;
    function  Previous(): Maybe<ItemType>; Virtual;
    function  First(): Maybe<ItemType>; Virtual;
    function  Last(): Maybe<ItemType>; Virtual;
    procedure Reset(); Virtual;
    function  ForEach(proc : TForEachFunction<ItemType>) : IIterator<ItemType>;
    function  LocalForEach(proc : TForEachFunction<ItemType>) : SelfType;
    function  Map(func : TMapFunction<ItemType>) : IIterator<ItemType>;
    function  LocalMap(func : TMapFunction<ItemType>) : SelfType;
    function  Filter(func : TFilterFunction<ItemType>) : IIterator<ItemType>;
    function  LocalFilter(func : TFilterFunction<ItemType>) : SelfType;
  end;

implementation

procedure TIterator<ItemType, SelfType>.Add(item: ItemType);
begin
  FItems.Add(item);
end;

function TIterator<ItemType, SelfType>.Count: integer;
begin
   Result := FItems.Count;
end;

constructor TIterator<ItemType, SelfType>.Create;
begin
  inherited;
  Initialize();
end;



function TIterator<ItemType, SelfType>.Current: Maybe<ItemType>;
begin
  Result := nil;
  if IsNotEmpty then
  begin
    if (FIndex >= 0) and (FIndex < Fitems.Count) then
    begin
      Result := FItems.Items[FIndex];
    end
    else
    begin
      Result := nil;;
    end;
  end;
end;

function TIterator<ItemType, SelfType>.Delete(Index: Integer): Boolean;
begin
  Result := False;
  Try
    if assigned(FItems[Index]) then
    begin
      FItems.Delete(Index);
      Result := true;
    end
  except
    {TODO -oOwner -cGeneral : ActionItem}
  End;
end;

destructor TIterator<ItemType, SelfType>.Destroy;
begin
  Finalize();
  inherited;
end;

function TIterator<ItemType, SelfType>.Filter(
  func: TFilterFunction<ItemType>): IIterator<ItemType>;
var
  NewIterator : TIterator<ItemType, SelfType>;
begin
  NewIterator := TIterator<ItemType, SelfType>.Create;
  if assigned(func) then
  begin
    ProcessFilter(func, NewIterator);
  end;
  Result := NewIterator;
end;


procedure TIterator<ItemType, SelfType>.Finalize;
begin
  FItems.Free;
end;

function TIterator<ItemType, SelfType>.First: Maybe<ItemType>;
begin
  if IsNotEmpty then
  begin
    Reset;
    Result := Current;
  end;
end;

function TIterator<ItemType, SelfType>.ForEach(
  proc: TForEachFunction<ItemType>): IIterator<ItemType>;
begin
  if assigned(proc) then
  begin
    ProcessForEach(proc, nil);
  end;

  Result := Self;
end;

procedure TIterator<ItemType, SelfType>.Initialize;
begin
  FIndex := -1;
  FItems := Tlist<ItemType>.Create;
end;

function TIterator<ItemType, SelfType>.IsEmpty: Boolean;
begin
  Result := Count <= 0;
end;

function TIterator<ItemType, SelfType>.IsNotEmpty: Boolean;
begin
  Result:= not IsEmpty;
end;

function TIterator<ItemType, SelfType>.Last: Maybe<ItemType>;
begin
  if IsNotEmpty then
  begin
    FIndex := Count-1;
    Result := Current;
  end;
end;

function TIterator<ItemType, SelfType>.LocalFilter(
  func: TFilterFunction<ItemType>): SelfType;
var
  NewIterator : SelfType;
begin
  NewIterator := self.NewIteratorConstructor;
  if assigned(func) then
  begin
    ProcessFilter(func, NewIterator as TIterator<ItemType, SelfType>);
  end;
  Result := NewIterator;
end;

function TIterator<ItemType, SelfType>.LocalForEach(
  proc: TForEachFunction<ItemType>): SelfType;
var
  NewIterator : SelfType;
begin
  NewIterator := self.NewIteratorConstructor;
  if assigned(proc) then
  begin
    ProcessForEach(proc, NewIterator as TIterator<ItemType, SelfType>);
  end;
  Result := NewIterator;
end;

function TIterator<ItemType, SelfType>.LocalMap(
  func: TMapFunction<ItemType>): SelfType;
var
  NewIterator : SelfType;
begin
  NewIterator := self.NewIteratorConstructor;
  if assigned(func) then
  begin
    ProcessMap(func, NewIterator as TIterator<ItemType, SelfType>);
  end;
  Result := NewIterator;
end;

function TIterator<ItemType, SelfType>.Map(
  func: TMapFunction<ItemType>): IIterator<ItemType>;
var
  NewIterator : TIterator<ItemType, SelfType>;
begin
  NewIterator := TIterator<ItemType, SelfType>.Create;
  if assigned(func) then
  begin
    ProcessMap(func, NewIterator);
  end;
  Result := NewIterator;
end;

function TIterator<ItemType, SelfType>.NewIteratorConstructor: SelfType;
begin
  result := nil;
end;

function TIterator<ItemType, SelfType>.Next: Maybe<ItemType>;
begin
  if IsNotEmpty then
  begin
    INC(FIndex);
    result := Current;
  end;
end;

function TIterator<ItemType, SelfType>.Previous: Maybe<ItemType>;
begin
  if IsNotEmpty then
  begin
    DEC(FIndex);
    Result := Current;
    if Not result.IsSome then
    begin
      INC(FIndex);
    end;
  end;
end;

procedure TIterator<ItemType, SelfType>.ProcessFilter(
  func: TFilterFunction<ItemType>; iter: TIterator<ItemType, SelfType>);
var
  stop : boolean;
  iteration : TIterator<ItemType , SelfType>;
begin
  iteration := iter;
  if IsNotEmpty then
  begin
    Reset;
    stop := false;
    repeat
      stop := next.bindTo<Boolean>
      (
        function(item : ItemType) : boolean
        begin
          if func(item) then
          begin
            if assigned(iteration) then
            begin
              iteration.FItems.Add(item);
            end;
          end;

          result := false;
        end,
        function() : boolean
        begin
          result := true;
        end
      );

    until stop;

  end;
end;

procedure TIterator<ItemType, SelfType>.ProcessForEach(
  proc: TForEachFunction<ItemType> ; iter : TIterator<ItemType , SelfType>);
var
  stop : boolean;
  iteration : TIterator<ItemType , SelfType>;
begin
  iteration := iter;
  if IsNotEmpty then
  begin
    Reset;
    stop := false;
    repeat
      stop := next.bindTo<Boolean>
      (
        function(item : ItemType) : boolean
        begin
          proc(item);
          if assigned(iteration) then
          begin
            iteration.FItems.Add(item);
          end;

          result := false;
        end,
        Function() : Boolean
        begin
          result := true;
        end
      );

    until stop;

  end;
end;

procedure TIterator<ItemType, SelfType>.ProcessMap(func: TMapFunction<ItemType>;
  iter: TIterator<ItemType, SelfType>);
var
  stop : boolean;
  iteration : TIterator<ItemType , SelfType>;
begin
  iteration := iter;
  if IsNotEmpty then
  begin
    Reset;
    stop := false;
    repeat
      stop := next.bindTo<Boolean>
      (
        function(item : ItemType) : boolean
        begin
          func(item).OnSome
          (
            procedure(newItem : ItemType)
            begin
              if assigned(iteration) then
              begin
                iteration.FItems.Add(newItem);
              end;
            end
          );
          result := false;
        end,
        Function() : Boolean
        begin
          result := true;
        end

      );

    until stop;

  end;
end;

procedure TIterator<ItemType, SelfType>.Reset;
begin
  FIndex := -1;
end;

end.
