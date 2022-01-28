unit uMainForm;

interface

uses
  DFE.Result,
  Data.DB,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMyDataset = Class(TDataSet)
  public
    function GetRecord(Buffer: TRecBuf; GetMode: TGetMode; DoCheck: Boolean): TGetResult; overload; override;
    function GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult; overload; override;
    procedure InternalClose; override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalOpen; override;
    function IsCursorOpen: Boolean; override;
  End;

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function OpenSQL(SQL : String) : TResult<TDataset, string>;
    Procedure VerifyDataset(Dataset : TDataset);
    Procedure ShowErrorMessage(ErrorMessage : String);

    Function VerifyDatasetAndReturnTrue(Dataset : TDataset) : boolean;
    Function ShowErrorMessageAndReturnFalse(ErrorMessage : String) : Boolean;

    Function OpenSqlAndVerifyDataset() : boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  OpenSQL('select * from master')
    .OnSuccess
    (
      procedure(dataset : Tdataset)
      begin
        if dataset.IsEmpty then
        begin
          ShowMessage('Dataset is empty');
        end;
      end
    )
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  OpenSQL('select * from person')
    .OnFail
    (
      procedure(ErrorMessage : string)
      begin
        ShowMessage(ErrorMessage);
      end
    )
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  OpenSQL('select * from person')
    .OnSuccess
    (
      procedure(dataset : Tdataset)
      begin
        if dataset.IsEmpty then
        begin
          ShowMessage('Dataset is empty');
        end;
      end
    )
    .OnFail
    (
      procedure(ErrorMessage : string)
      begin
        ShowMessage(ErrorMessage);
      end
    )
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  OpenSQL('select * from person')
    .Bind
    (
      procedure(dataset : Tdataset)
      begin
        if dataset.IsEmpty then
        begin
          ShowMessage('Dataset is empty');
        end;
      end
    ,
      procedure(ErrorMessage : string)
      begin
        ShowMessage(ErrorMessage);
      end
    )
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  OpenSQL('select * from master')
    .OnSuccess(VerifyDataset)
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  OpenSQL('select * from person')
    .OnFail(ShowErrorMessage)

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  OpenSQL('select * from person')
    .OnSuccess(VerifyDataset)
    .OnFail(ShowErrorMessage)
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  OpenSQL('select * from person')
    .Bind(VerifyDataset,ShowErrorMessage)
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  if OpenSqlAndVerifyDataset then
  begin
    ShowMessage('ok');
  end
  else
  begin
    ShowMessage('Not work');
  end;
end;

function TForm1.OpenSQL(SQL: String): TResult<TDataset, string>;
begin
  if LowerCase(SQL) = 'select * from master' then
  begin
    Result := TMyDataset.Create(nil);
  end
  else
  begin
    result := 'Syntax error.';
  end;
end;

function TForm1.OpenSqlAndVerifyDataset: boolean;
begin
  Result :=
  OpenSQL('select * from person')
    .BindTo<Boolean>(VerifyDatasetAndReturnTrue,ShowErrorMessageAndReturnFalse);
end;

procedure TForm1.ShowErrorMessage(ErrorMessage: String);
begin
  ShowMessage(ErrorMessage);
end;

function TForm1.ShowErrorMessageAndReturnFalse(ErrorMessage: String): Boolean;
begin
  ShowErrorMessage(ErrorMessage);
  Result := False;
end;

procedure TForm1.VerifyDataset(Dataset: TDataset);
begin
  if Dataset.IsEmpty then
  begin
    ShowMessage('Dataset is empty');
  end;
end;

function TForm1.VerifyDatasetAndReturnTrue(Dataset: TDataset): boolean;
begin
  VerifyDataset(Dataset);
  Result := true;
end;

{ TMyDataset }

function TMyDataset.GetRecord(Buffer: TRecBuf; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  result := grOK;
end;

function TMyDataset.GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  result := grOK;
end;

procedure TMyDataset.InternalClose;
begin
  inherited;

end;

procedure TMyDataset.InternalHandleException;
begin
  inherited;

end;

procedure TMyDataset.InternalInitFieldDefs;
begin
  inherited;

end;

procedure TMyDataset.InternalOpen;
begin
  inherited;

end;

function TMyDataset.IsCursorOpen: Boolean;
begin
  Result := false;
end;

end.
