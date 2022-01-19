unit DFE.Maybe;

interface

uses
  system.Classes,
  SysUtils;
type
  Maybe<T> = record
  private
    type TSomeProc      = reference to procedure(some : T);
    type TSomeBoolFunc  = reference to function(some : T) : Boolean;
    type TNoneProc      = reference to procedure();
    type TNoneBoolFunc  = reference to function() : Boolean;
  strict private
    fValue: T;
    fHasValue: string;
  public
    constructor Create(const value: T);
    function Any: Boolean; inline;
    function GetValueOrDefault(const default: T): T;
    function OnSome(SomeCallback : TSomeProc) : Maybe<T>;
    function OnNone(NoneCallback : TNoneProc) : Maybe<T>;

    Function Bind(Left : TSomeProc ; Rigth : TNoneProc = nil) : Maybe<T>; Overload;
    Function Bind(Left : TSomeBoolFunc ; Rigth : TNoneBoolFunc = nil) : Boolean; Overload;
    class operator Implicit(const value: T): Maybe<T>;
  end;
implementation
function Maybe<T>.Bind(Left: TSomeBoolFunc; Rigth: TNoneBoolFunc): Boolean;
begin
  if self.Any then
  BEGIN
    Result := Left(fValue);
  END
  else
  if assigned(Rigth) then
  begin
    Result := Rigth();
  end
  else
  begin
    result := false;
  end;

end;

constructor Maybe<T>.Create(const value: T);
begin
 case GetTypeKind(T) of
    tkClass, tkInterface, tkClassRef, tkPointer, tkProcedure:
    if (PPointer(@value)^ = nil) then
    begin
      fHasValue := '';
      exit;
    end;

  end;
  fValue := value;
  fHasValue := '@';
end;
function Maybe<T>.Any: Boolean;
begin
  Result := fHasValue <> '';
end;
function Maybe<T>.GetValueOrDefault(const default: T): T;
begin
  if Any then
    Exit(fValue);
  Result := default;
end;

class operator Maybe<T>.Implicit(const value: T): Maybe<T>;
begin
  Result := Maybe<T>.Create(value);
end;
function Maybe<T>.OnNone(NoneCallback: TNoneProc): Maybe<T>;
begin
  if Not self.Any then
  BEGIN
    NoneCallback;
  END;
  Result := self;
end;

function Maybe<T>.OnSome(SomeCallback: TSomeProc): Maybe<T>;
begin
  if self.Any then
  BEGIN
    SomeCallback(fValue);
  END;
  Result := self;
end;

Function Maybe<T>.Bind(Left: TSomeProc; Rigth: TNoneProc) : Maybe<T>;
begin
  if self.Any then
  BEGIN
    Left(fValue);
  END
  else
  if assigned(Rigth) then
  begin
    Rigth();
  end;

  Result := self;

end;


end.
