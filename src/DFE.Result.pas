unit DFE.Result;

interface

uses
  system.Classes,
  SysUtils;
type
  TResult<TSuccess, TFail> = record
  private
    type TSuccesCallback = reference to procedure(SuccessResult : TSuccess);
    type TFailCallback   = reference to procedure(FailResult : TFail);
    Type TSuccessToCallback<ReturnType> = reference to function(SuccessResult : TSuccess) : ReturnType;
    Type TFailToCallback<ReturnType> = reference to function(FailResult : TFail) : ReturnType;
    Procedure Initialize;
    procedure NewSuccess(const success: TSuccess);
    procedure NewFail(const fail: TFail);
  strict private

    FSuccess: TSuccess;
    FFail : TFail;
    fHasValue: string;
    FIsSuccess : Boolean;
    FIsFail : Boolean;
  public
    class operator Implicit(const value: TSuccess): TResult<TSuccess, TFail>; Overload;
    class operator Implicit(const value: TFail): TResult<TSuccess, TFail>; Overload;

  public
    property IsSuccess: Boolean read FIsSuccess;
    property IsFaill: Boolean read FIsFail;



    Function  OnSuccess(callback : TSuccesCallback) : TResult<TSuccess, TFail>;
    Function  OnFail(callback : TFailCallback) : TResult<TSuccess, TFail>;

    Function  Bind(SuccessCallback : TSuccesCallback ; FailCallback : TFailCallback) : TResult<TSuccess, TFail>;
    Function  BindTo<ReturnType>
    (
      SuccessCallback : TSuccessToCallback<ReturnType> ;
      FailCallback : TFailToCallback<ReturnType>
    ) : ReturnType;




  end;
implementation


{ TResult<TSuccess, TFail> }

class operator TResult<TSuccess, TFail>.Implicit(
  const value: TSuccess): TResult<TSuccess, TFail>;
begin
  Result.NewSuccess(value);
end;

function TResult<TSuccess, TFail>.Bind(SuccessCallback: TSuccesCallback;
  FailCallback: TFailCallback): TResult<TSuccess, TFail>;
begin
  result := OnSuccess(SuccessCallback).OnFail(FailCallback);
end;

function TResult<TSuccess, TFail>.BindTo<ReturnType>(
  SuccessCallback: TSuccessToCallback<ReturnType>;
  FailCallback: TFailToCallback<ReturnType>): ReturnType;
begin
  if self.IsSuccess then
  begin
    Result := SuccessCallback(FSuccess)
  end
  else
  begin
    Result := FailCallback(Ffail)
  end;
end;

class operator TResult<TSuccess, TFail>.Implicit(const value: TFail): TResult<TSuccess, TFail>;
begin
  Result.NewFail(value);
end;

procedure TResult<TSuccess, TFail>.Initialize;
begin
  FIsSuccess := false;
  FIsFail := false;
end;



procedure TResult<TSuccess, TFail>.NewFail(const fail: TFail);
begin
  Initialize;
  case GetTypeKind(TFail) of
    tkClass, tkInterface, tkClassRef, tkPointer, tkProcedure:
    if (PPointer(@fail)^ = nil) then
      exit
  end;

  FFail := fail;
  fHasValue := '@';
  FisFail := true;
end;

procedure TResult<TSuccess, TFail>.NewSuccess(const success: TSuccess);
begin
  Initialize;
  case GetTypeKind(TSuccess) of
    tkClass, tkInterface, tkClassRef, tkPointer, tkProcedure:
    if (PPointer(@success)^ = nil) then
      exit
  end;

  FSuccess := Success;
  fHasValue := '@';
  FisSuccess := true;
end;

function TResult<TSuccess, TFail>.OnFail(
  callback: TFailCallback): TResult<TSuccess, TFail>;
begin
  if self.IsFaill then
  BEGIN
    callback(FFail);
  END;

  Result := self;
end;

function TResult<TSuccess, TFail>.OnSuccess(
  callback: TSuccesCallback): TResult<TSuccess, TFail>;
begin
  if self.IsSuccess then
  BEGIN
    callback(FSuccess);
  END;

  Result := self;
end;

end.
