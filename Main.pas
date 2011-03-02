unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Grids, DBGrids, Db, DBTables, Mask, DBCtrls,
  dialerPlus;

type
  TMainForm = class(TForm)
    Dial: TButton;
    NTLcheck: TCheckBox;
    StatusBar: TStatusBar;
    DBName: TDBEdit;
    DBNumber: TDBEdit;
    NameLbl: TLabel;
    NumberLbl: TLabel;
    Table: TTable;
    DataSource: TDataSource;
    DBNavigator: TDBNavigator;
    DBGrid: TDBGrid;
    CurrentTimeLbl: TLabel;
    CurrentTime: TTimer;
    CurrentDateLbl: TLabel;
    MyComPortCb: TComboBox;
    MobileRb: TCheckBox;
    WeekendRb: TCheckBox;
    procedure DialClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CurrentTimeTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NTLcheckClick(Sender: TObject);
    procedure WeekendRbClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure DialNumber;
    Procedure DBNTLno;
    Procedure DBno;
    Procedure SetRate;
    Procedure ReadInSettings;
    Procedure SaveSettings;
    Procedure ReadInPhoneRates;
  end;

var
  MainForm: TMainForm;
  NameCalled, NumberCalled, PhoneNumber, Status, Ext,Daytime,Evening,Weekend,Mobile,Minimum:string;
  Rate:real;
  Filein, Fileout:TextFile;
  DateTime:TDateTime;
  Hour, Min, Sec, MSec:Word;

implementation

uses Response;

{$R *.DFM}

procedure TMainForm.DialClick(Sender: TObject);
begin
  DateTime:=Time;
  DecodeTime(DateTime,Hour,Min,Sec,MSec);
  SetRate;

  if rate>0 then
    begin
      DBno;         //Phones via Normal BT Line
      DBNTLno;      //Phones via NTL Service (Default)
    end
  else
    begin
      ShowMessage('Phone Rate Not Specified, Please Report Error');
    end;
end;

procedure TMainForm.DBno;  //Checks Number Field in Edit Box has text & NTL has been unchecked
begin
  if (DBNumber.Text <> '') and (NTLCheck.Checked=false) then
    begin
      NameCalled:=DBName.Text;          //The Name of the Person called
      NumberCalled:=DBNumber.Text;      //The Number of the Person called

      PhoneNumber:=DBNumber.Text;
      DialNumber;  //Dial Phone Number
    end;
end;

procedure TMainForm.DBNTLno;
begin
  if (DBNumber.Text <> '') and (NTLCheck.Checked=true) then  //Checks Number Field in Edit Box has text & NTL has been checked
    begin
      NameCalled:=DBName.Text;          //The Name of the Person called
      NumberCalled:=Ext+DBNumber.Text;      //The Number of the Person called

      PhoneNumber:=Ext+DBNumber.Text;
      DialNumber;  //Dial Phone Number
    end;
end;

procedure TMainForm.Dialnumber; //Dials the Specified Phone Number (PhoneNumber) via the Phone Dialer
var TempDialer : TDialer;
begin

if (PhoneNumber='') or (PhoneNumber=Ext) then   //Checks that there is a number specified
  begin
    ShowMessage('No Phone Number Found');  //shows pop-up message
  end
else
  begin
    TempDialer:=TDialer.Create(Self);
    with TempDialer do
      begin
        NumberToDial:=PhoneNumber;  //Set PhoneNumber

        //Set which COM Port to use
        If MyComPortCb.text='COM1' then ComPort:=dpCom1
          Else If MyComPortCb.text='COM2' then ComPort:=dpCom2
            Else If MyComPortCb.text='COM3' then ComPort:=dpCom3
              Else If MyComPortCb.text='COM4' then ComPort:=dpCom4
                Else
                  begin
                    Showmessage('Com Port Not Set Correctly');
                    Exit;
                  end;

        //Set Other TempDialer Options
        Confirm:=false;
        Language:=dlEnglish;
        DialCommand:='ATDT';

        //Dial Number, Show Result & Destroy Dialer
        Status:=Execute;
        Free;
      end;

    StatusBar.SimpleText:='Dialing... ' + PhoneNumber;  //Shows Dialing text on statusbar
    ResponseForm.Visible:=true;
    MainForm.Visible:=false;
  end;

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if FileExists(ExtractFilePath(ParamStr(0))+'PD.DB') and FileExists(ExtractFilePath(ParamStr(0))+'PD.PX') then
    begin
      Table.DatabaseName:=ExtractFilePath(ParamStr(0));
      Table.TableName:='PD.DB';
      Table.Active:=true;

      CurrentTimeLbl.Caption:=TimeToStr(Time);
      CurrentDate:=DateToStr(Date);
      CurrentDateLbl.Caption:=CurrentDate;

      ReadInSettings;
      ReadInPhoneRates;
    end
  else
    begin
      Showmessage('The Database is not found in the current folder');
      Application.Terminate;
    end;
end;

procedure TMainForm.SetRate;
begin
  If (WeekendRb.Checked=true) and (MobileRb.Checked=true) then
    begin
      Showmessage('You cannot have ');
      Exit;
    end;
  If WeekendRb.Checked=true then rate:=StrToFloat(Weekend)
    else if MobileRb.Checked=true then rate:=StrToFloat(Mobile)
      else if (Hour>=8) and (Hour<=17) then rate:=StrToFloat(Daytime)
        else if (Hour>=18) or (Hour<=7) then rate:=StrToFloat(Evening)
          else rate:=0;
end;

procedure TMainForm.CurrentTimeTimer(Sender: TObject);
begin
  CurrentTimeLbl.Caption:=TimeToStr(Time);
end;

procedure TMainForm.ReadInSettings;
var MyCOM,Selected:string;
    PhoneCo:string[26];
begin
  If FileExists(ExtractFilePath(ParamStr(0))+'settings.dat') then
    begin
      AssignFile(Filein,'settings.dat');
      Reset(Filein);
      Readln(Filein,Ext);
      Readln(Filein,PhoneCo);
      Readln(Filein,Selected);
      Readln(Filein,MyCom);
      CloseFile(Filein);

      Selected:=upcase(Selected[1]);
      if (Selected='T') then NTLCheck.checked:=true
        else if (Selected='F') then NTLCheck.checked:=false
          else showmessage('PhoneCo Not Set');

      MyComPortCb.text:=MyCOM;
      NTLCheck.caption:=PhoneCo;
    end;

end;

procedure TMainForm.SaveSettings;

FUNCTION FileOk: BOOLEAN;

BEGIN
  {$I-}
  AssignFile(Fileout,'settings.dat');
  ReWrite(Fileout);
  CloseFile(Fileout);
  {$I+}
  FileOK:= (IOResult = 0);
END;

begin
  If FileOK=false then
    begin
      showmessage('Settings Can Not Be Saved, File Is Read-Only');
    end
  else
    begin
      If FileExists(ExtractFilePath(ParamStr(0))+'settings.dat') then
        begin
          DeleteFile(ExtractFilePath(ParamStr(0))+'settings.dat');
        end;

      AssignFile(Fileout,'settings.dat');
      ReWrite(Fileout);
      Writeln(Fileout,Ext);
      Writeln(Fileout,NTLCheck.caption);
      If NTLCheck.Checked=true then Writeln(Fileout,'T')
        Else If NTLCheck.Checked=false then Writeln(Fileout,'F');

      Writeln(Fileout,MyComPortCb.Text);

      CloseFile(Fileout);
    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TMainForm.ReadInPhoneRates;
begin

  If NTLCheck.Checked=true then
    begin
     If FileExists(ExtractFilePath(ParamStr(0))+'rates2.dat') then
       begin
         AssignFile(Filein,'rates2.dat');
         Reset(Filein);
         Readln(Filein,Daytime);
         Readln(Filein,Evening);
         Readln(Filein,Weekend);
         Readln(Filein,Mobile);
         Readln(Filein,Minimum);
         CloseFile(Filein);
       end;
    end
  else
   begin
     If FileExists(ExtractFilePath(ParamStr(0))+'rates.dat') then
       begin
         AssignFile(Filein,'rates.dat');
         Reset(Filein);
         Readln(Filein,Daytime);
         Readln(Filein,Evening);
         Readln(Filein,Weekend);
         Readln(Filein,Mobile);
         Readln(Filein,Minimum);
         CloseFile(Filein);
       end;
   end;

end; {End Procedure}

procedure TMainForm.NTLcheckClick(Sender: TObject);
begin
  ReadInPhoneRates;
end;

procedure TMainForm.WeekendRbClick(Sender: TObject);
begin
  If MobileRb.Checked=true then WeekendRb.Checked:=false;
end;

end.




