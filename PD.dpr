program PD;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Response in 'Response.pas' {ResponseForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Phone Dialer+';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TResponseForm, ResponseForm);
  Application.Run;
end.
