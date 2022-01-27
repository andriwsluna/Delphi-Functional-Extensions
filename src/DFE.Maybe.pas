unit DFE.Maybe;

interface

uses
  system.Classes,
  SysUtils;
type
  Maybe<T> = record
  private
    type TSomeProc      = reference to procedure(some : T);
    type TSomeConstProc = reference to procedure(const some : T);
    type TNoneProc      = reference to procedure();

    Type TSomeProcReturn<ReturnType> = reference to function(some : T) : ReturnType;
    Type TSomeConstProcReturn<ReturnType> = reference to function(Const some : T) : ReturnType;
    Type TNoneProcReturn<ReturnType> = reference to function() : ReturnType;

  strict private
    fValue: T;
    fHasValue: string;
  public
    constructor Create(const value: T);
    function IsSome: Boolean; inline;
    function GetValueOrDefault(const default: T): T;
    function OnSome(SomeCallback : TSomeProc) : Maybe<T>; Overload;
    function OnSome(SomeCallback : TSomeConstProc) : Maybe<T>; Overload;
    function OnNone(NoneCallback : TNoneProc) : Maybe<T>;

    Function Bind(Left : TSomeProc ; Rigth : TNoneProc = nil) : Maybe<T>;  Overload;
    Function Bind(Left : TSomeConstProc ; Rigth : TNoneProc = nil) : Maybe<T>; Overload;

    Function BindTo<ReturnType>(Left : TSomeProcReturn<ReturnType> ; Rigth : TNoneProcReturn<ReturnType>) : ReturnType; Overload;
    Function BindTo<ReturnType>(Left : TSomeConstProcReturn<ReturnType> ; Rigth : TNoneProcReturn<ReturnType>) : ReturnType; Overload;
    Function BindToWith<ReturnType>(Left : ReturnType ; Rigth : ReturnType) : ReturnType; Overload;

    class operator Implicit(const value: T): Maybe<T>;
  end;
implementation


function Maybe<T>.BindTo<ReturnType>(Left: TSomeProcReturn<ReturnType>;
  Rigth: TNoneProcReturn<ReturnType>): ReturnType;
begin
  if self.IsSome then
  BEGIN
    Result := Left(fValue);
  END
  else
  begin
    Result := Rigth();
  end;
end;



function Maybe<T>.Bind(Left: TSomeConstProc; Rigth: TNoneProc): Maybe<T>;
begin
  if self.IsSome then
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

function Maybe<T>.BindTo<ReturnType>(Left: TSomeConstProcReturn<ReturnType>;
  Rigth: TNoneProcReturn<ReturnType>): ReturnType;
begin
  if self.IsSome then
  BEGIN
    Result := Left(fValue);
  END
  else
  begin
    Result := Rigth;
  end;
end;


function Maybe<T>.BindToWith<ReturnType>(Left, Rigth: ReturnType): ReturnType;
begin
  if self.IsSome then
  BEGIN
    Result := Left;
  END
  else
  begin
    Result := Rigth;
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
function Maybe<T>.IsSome: Boolean;
begin
  Result := fHasValue <> '';
end;
function Maybe<T>.GetValueOrDefault(const default: T): T;
begin
  if IsSome then
    Exit(fValue);
  Result := default;
end;

class operator Maybe<T>.Implicit(const value: T): Maybe<T>;
begin
  Result := Maybe<T>.Create(value);
end;
function Maybe<T>.OnNone(NoneCallback: TNoneProc): Maybe<T>;
begin
  if Not self.IsSome then
  BEGIN
    NoneCallback;
  END;
  Result := self;
end;

function Maybe<T>.OnSome(SomeCallback: TSomeConstProc): Maybe<T>;
begin
  if self.IsSome then
  BEGIN
    SomeCallback(fValue);
  END;
  Result := self;
end;

function Maybe<T>.OnSome(SomeCallback: TSomeProc): Maybe<T>;
begin
  if self.IsSome then
  BEGIN
    SomeCallback(fValue);
  END;
  Result := self;
end;



Function Maybe<T>.Bind(Left: TSomeProc; Rigth: TNoneProc) : Maybe<T>;
begin
  if self.IsSome then
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
