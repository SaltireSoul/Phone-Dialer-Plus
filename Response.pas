unit Response;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TResponseForm = class(TForm)
    StartBtn: TButton;
    Timer: TTimer;
    Panel: TPanel;
    MinsLbl: TLabel;
    SecsLbl: TLabel;
    HrsLbl: TLabel;
    Seperator2Lbl: TLabel;
    Seperator1Lbl: TLabel;
    ReturnBtn: TButton;
    Log: TMemo;
    procedure StartBtnClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ReturnBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Refresh;
    procedure Finish;
    procedure SaveLog;
    Procedure CalculatePrice;
  end;

var
  ResponseForm: TResponseForm;
  Secs,Mins,Hrs:integer;
  Filename:string;
  CurrentDate,StartTime,FinishTime:string;
  Price:Real;

implementation

uses Main;

{$R *.DFM}

procedure TResponseForm.refresh;
begin
  SecsLbl.Caption:=IntToStr(Secs);
  MinsLbl.Caption:=IntToStr(Mins);
  HrsLbl.Caption:=IntToStr(Hrs);
end;

procedure TResponseForm.finish;
begin
  ResponseForm.Visible:=false;
  MainForm.Visible:=true;
  MainForm.StatusBar.SimpleText:='';
end;

procedure TResponseForm.SaveLog;
begin
  FinishTime:=TimeToStr(Time);
  CalculatePrice;

{
  Log.Lines.Add(NumberCalled + ',' + NameCalled + ',' + IntToStr(Hrs)+':'+IntToStr(Mins)+':'+IntToStr(Secs)+ ',' +FloatToStrF(Price,ffFixed,7,3)+ ',' +CurrentDate+ ',' +StartTime+ ',' +FinishTime);
}
  Log.Lines.Add(NumberCalled +',' +NameCalled +',' +FloatToStrF(Price,ffFixed,7,3)+ ',' +CurrentDate);


  Log.Lines.SaveToFile(Filename);
  ShowMessage('The Call Cost '+FloatToStrF(Price,ffCurrency,7,3));
end;

procedure TResponseForm.ReturnBtnClick(Sender: TObject);
begin
  Timer.Enabled:=false;
  SaveLog;
  Finish;
end;

procedure TResponseForm.StartBtnClick(Sender: TObject);
begin
  StartTime:=TimeToStr(Time);
  Secs:=1;
  Mins:=0;
  Hrs:=0;

  refresh;

  Timer.Enabled:=true;
  StartBtn.Enabled:=false;
end;

procedure TResponseForm.TimerTimer(Sender: TObject);
begin
  inc(secs);

  if secs = 60 then
    begin
      secs:=0;
      inc(mins);
    end;

  if mins = 60 then
    begin
      mins:=0;
      inc(hrs);
    end;

  Refresh;
end;

procedure TResponseForm.FormShow(Sender: TObject);
begin
  Filename:=ExtractFilePath(ParamStr(0))+'Log.txt';
  if FileExists(filename) then
    begin
      Log.Lines.LoadFromFile(Filename);
    end
  else
    begin
{
      Log.Lines.Add('Name' + ',' + 'Number' + ',' + 'Duration' + ',' + 'Cost' + ',' + 'Date' + ',' + 'Started Call' + ',' + 'Finished Call');
}
      Log.Lines.Add('Number,Name,Cost,Date');
    end;

  Secs:=0;
  Mins:=0;
  Mins:=0;
  StartBtn.Enabled:=true;
  Refresh;

  If Status='OK' then StartBtnClick(sender);
end;

procedure TResponseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ReturnBtnClick(sender);
end;

procedure TResponseForm.CalculatePrice;
var value, RealRate:real;
begin
  Value:=(Hrs*60*60)+(Mins*60)+(Secs);

  RealRate:=Rate/60;
  Price:=((Value*RealRate)/100);

  If Price<(StrToFloat(Minimum)/100) then
    Price:=StrToFloat(Minimum)/100;
end;

end.
