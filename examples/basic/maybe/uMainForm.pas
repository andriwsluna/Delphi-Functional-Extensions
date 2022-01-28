unit uMainForm;

interface

uses
  DFE.Maybe,
  Winapi.Windows, Winapi.Messages, System.SysUtils, system.DateUtils,System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TPerson = Class
  strict private
    FName : String;
    FAge : integer;
  public
    property Name: String read FName;
    property Age : Integer read FAge;

    Constructor Create(Const Name : String; Age : Integer); Reintroduce;
    Function ToString() : String; Override;
  end;

  TMainForm = class(TForm)
    ButtonGetPersonWithAnonimous: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure ButtonGetPersonWithAnonimousClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    Procedure ShowPerson(Const Person : TPerson);
    Procedure ShowErrorMessage();
    Function  ShowPersonAndReturnTrue(Const Person : TPerson) : Boolean;
    Function  ShowErrorMessageAndResurnFalse() : Boolean;
  public
    Function GetPerson(Name : String) : Maybe<TPerson>;


  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

{ TPerson }

constructor TPerson.Create(const Name: String; Age: Integer);
begin
  inherited create();
  self.FName := Name;
  Self.FAge := Age;
end;

function TPerson.ToString: String;
begin
  Result := 'My name is ' + self.Name + ', my age is ' + self.Age.ToString + ' years old.';
end;

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin
  GetPerson('Java')
    .OnNone
    (
      procedure
      begin
        ShowMessage('Java is nicklename of Pumba.');
      end
    );
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  GetPerson('Java')
    .OnSome
    (
      procedure(person : TPerson)
      begin
        ShowMessage('Never call me');
      end
    )
    .OnNone
    (
      procedure
      begin
        ShowMessage('Java is nicklename of Pumba.');
      end
    );
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  GetPerson('Java')
    .Bind
    (
      procedure(person : TPerson)
      begin
        ShowMessage('Never call me');
      end
      ,
      procedure
      begin
        ShowMessage('Java is nicklename of Pumba.');
      end
    );
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  GetPerson('Java').OnNone(ShowErrorMessage);
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  GetPerson('Delphi').OnSome(ShowPerson);
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  GetPerson('Delphi')
    .OnSome(ShowPerson)
    .OnNone(ShowErrorMessage)
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  GetPerson('Delphi').Bind(ShowPerson, ShowErrorMessage)
end;

procedure TMainForm.Button8Click(Sender: TObject);
begin
  if
  (
    GetPerson('Delphi')
      .BindTo<Boolean> //Define de return type here
      (
        ShowPersonAndReturnTrue,              //Functions thats return a boolean
        ShowErrorMessageAndResurnFalse
      )
  ) then
  begin
    ShowMessage('It''s OK');
  end
  else
  begin
    ShowMessage('It''s Bad');
  end;

end;

procedure TMainForm.ButtonGetPersonWithAnonimousClick(Sender: TObject);
begin
  GetPerson('Delphi')
    .OnSome
    (
      procedure(person : TPerson)
      begin
        ShowMessage(person.ToString());
      end
    );
end;



function TMainForm.GetPerson(Name: String): Maybe<TPerson>;
begin
  if Name = 'Delphi' then
  begin
    Result := TPerson.Create('Delphi',YearOf(now)  - 1995);
  end;
end;

procedure TMainForm.ShowErrorMessage;
begin
  ShowMessage('No person founded.');
end;

function TMainForm.ShowErrorMessageAndResurnFalse: Boolean;
begin
  ShowErrorMessage;
  Result := False;
end;

procedure TMainForm.ShowPerson(const Person: TPerson);
begin
  ShowMessage(Person.ToString);
end;

function TMainForm.ShowPersonAndReturnTrue(const Person: TPerson): Boolean;
begin
  ShowPerson(Person);
  Result := True;
end;

end.
