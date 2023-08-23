unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, inifiles, ExtCtrls, ImgList, ComCtrls, ToolWin, ShellApi,
  Menus;
const 
  CM_RESTORE = WM_USER + $1000;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    SpeedButton1: TSpeedButton;
    Image6: TImage;
    Persona: TEdit;
    Movil: TEdit;
    Casa: TEdit;
    Oficina: TEdit;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton2: TToolButton;
    grupo: TComboBox;
    Panel1: TPanel;
    icono: TImage;
    ImageList1: TImageList;
    Panel3: TPanel;
    Image7: TImage;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    PopupMenu1: TPopupMenu;
    Minimizar1: TMenuItem;
    Desplegar1: TMenuItem;
    Iconizar1: TMenuItem;
    N1: TMenuItem;
    Cerrar1: TMenuItem;
    Abrir: TOpenDialog;
    Panel4: TPanel;
    SiempreVisible1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PersonaChange(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure PersonaKeyPress(Sender: TObject; var Key: Char);
    procedure grupoChange(Sender: TObject);
    procedure Image6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image6Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Panel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Image7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image7Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    IconData : TNotifyIconData;
    procedure Espabila(var Msg : TMessage); message WM_USER+1;

  public
    { Public declarations }
    telefonos:tinifile;
    fichero:string;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RestoreRequest(var message: TMessage); message CM_RESTORE;
  end;

var
  Form1: TForm1;

implementation
uses
unit2, unit3, Unit4;

{$R *.DFM}

procedure TForm1.CreateParams(var Params: TCreateParams);
begin 
  inherited CreateParams(Params);
  Params.WinClassName := 'Agenda Telefonos';
end; 
 
procedure TForm1.RestoreRequest(var message: TMessage);
begin
// si esta iconizada
if not form1.visible then begin
       iconizar1.caption:='&Iconizar';
       SetForegroundWindow(Handle);
       Form1.Show;
       ShowWindow(Application.Handle, SW_show);
      Shell_NotifyIcon(NIM_DELETE, @IconData);
      IconData.Wnd:=0;
      exit;
end;

// si esta minimizada
if IsIconic(Application.Handle) = TRUE then Application.Restore
// si esta normal
else Application.BringToFront;

end;

procedure TForm1.Espabila(var Msg : TMessage);
{Aqui se recibe la pulsacion sobre el icono}
{Here we recieve the click on the icon}
var 
  p : TPoint;
begin
  if Msg.lParam = WM_RBUTTONDOWN then begin
  SetForegroundWindow(Handle);
  GetCursorPos(p);
  minimizar1.Enabled:=false;
  desplegar1.enabled:=false;
  SiempreVisible1.enabled:=false;
  PopupMenu1.Popup(p.x, p.y);
  PostMessage(Handle, WM_NULL, 0, 0);
  exit;
  end;

if Msg.lParam = WM_LBUTTONUP then begin
  iconizar1.caption:='&Iconizar';
  SetForegroundWindow(Handle);
  Form1.Show;
  ShowWindow(Application.Handle, SW_show);
  {Y nos cargamos el icono de la system tray}
  {Destroy the systray icon}
  Shell_NotifyIcon(NIM_DELETE, @IconData);
  IconData.Wnd:=0;
end;

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
//abrir.InitialDir:=extractfilepath(application.exename);
if (paramcount>0) and (paramstr(1)[1]<>'/') then begin
 if extractfilepath(paramstr(1))<>'' then fichero:=paramstr(1)
 else fichero:=extractfilepath(application.exename)+paramstr(1);
end

else fichero:=changefileext(application.exename,'.TLF');
telefonos:=tinifile.create(fichero);
telefonos.ReadSection('GRUPOS',grupo.items);
grupo.Sorted:=true;
form1.top:=telefonos.ReadInteger('CFG','Top',100);
form1.Left:=telefonos.ReadInteger('CFG','Left',100);

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if toolbutton1.Enabled then begin
  telefonos.writeinteger('CFG','Top',form1.Top);
  telefonos.writeinteger('CFG','Left',form1.left);
end;
telefonos.free;
end;

procedure TForm1.PersonaChange(Sender: TObject);
var
texto:string;

begin
if persona.text<>'' then begin
  movil.text:=telefonos.readstring('MOVIL',persona.text,'');
  casa.text:=telefonos.readstring('CASA',persona.text,'');
  oficina.text:=telefonos.readstring('OFICINA',persona.text,'');
  grupo.ItemIndex:=grupo.items.indexof(telefonos.readstring('GRUPO',persona.text,''));

  if grupo.ItemIndex>-1 then Imagelist1.Geticon(telefonos.readinteger('GRUPOS',grupo.text,-1),icono.Picture.Icon)
  else Imagelist1.Geticon(-1,icono.Picture.Icon);


end
else begin
movil.text:='';
casa.text:='';
oficina.text:='';
grupo.itemindex:=-1;
Imagelist1.Geticon(-1,icono.Picture.Icon);
end;


end;


procedure TForm1.BitBtn4Click(Sender: TObject);
begin
if (persona.text='') or
((movil.text='') and (casa.text='') and (oficina.text='')) then exit;

if movil.text='' then  telefonos.DeleteKey('MOVIL',persona.text)
else telefonos.writestring('MOVIL',persona.text,movil.text);

if casa.text='' then telefonos.DeleteKey('CASA',persona.text)
else telefonos.writestring('CASA',persona.text,casa.text);

if oficina.text='' then telefonos.DeleteKey('OFICINA',persona.text)
else telefonos.writestring('OFICINA',persona.text,oficina.text);

if grupo.text='' then telefonos.DeleteKey('GRUPOS',persona.text)
else telefonos.writestring('GRUPO',persona.text,grupo.text);
persona.SetFocus;
persona.SelectAll;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
if persona.text='' then exit;
if application.MessageBox('¿Seguro que quieres Borrar la Ficha?','Agenda Telefonos',mb_okcancel+mb_iconexclamation)=id_ok then begin
telefonos.deletekey('MOVIL',persona.text);
telefonos.deletekey('CASA',persona.text);
telefonos.deletekey('OFICINA',persona.text);
persona.text:='';
end;

end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
Application.CreateForm(TForm2, Form2);
form2.showmodal;
form2.free;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
Application.CreateForm(TForm3, Form3);
form3.showmodal;
form3.free;
grupo.Sorted:=false;
telefonos.ReadSection('GRUPOS',grupo.items);
grupo.Sorted:=true;
PersonaChange(nil);
end;

procedure TForm1.PersonaKeyPress(Sender: TObject; var Key: Char);
begin
if key in ['=','[',']'] then key:=chr(0);
if key=chr(27) then persona.text:='';
end;

procedure TForm1.grupoChange(Sender: TObject);
begin
Imagelist1.Geticon(telefonos.readinteger('GRUPOS',grupo.text,-1),icono.Picture.Icon);
end;

procedure TForm1.Image6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
image6.top:=image6.top+1;
image6.left:=image6.left+1;
end;

procedure TForm1.Image6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
image6.top:=image6.top-1;
image6.left:=image6.left-1;

end;

procedure TForm1.Image6Click(Sender: TObject);
begin
Application.CreateForm(TForm4, Form4);
form4.showmodal;
form4.free;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Panel3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 ReleaseCapture;
 Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
if iconizar1.caption='&Iconizar' then begin
iconizar1.caption:='&Restaurar';
with IconData do
    begin
      cbSize := sizeof(IconData);
      Wnd := Handle;
      uID := 100;
      uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
      uCallbackMessage := WM_USER + 1;
      hIcon := form1.Icon.Handle;
      StrPCopy(szTip, Application.Title+' ['+extractfilename(fichero)+']');
    end;
    Shell_NotifyIcon(NIM_ADD, @IconData);
    Hide;
end// de iconizar
else begin
  iconizar1.caption:='&Iconizar';
  Form1.Show;
  ShowWindow(Application.Handle, SW_show);
  {Y nos cargamos el icono de la system tray}
  Shell_NotifyIcon(NIM_DELETE, @IconData);
  IconData.Wnd:=0;
end;
end;


procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
if form1.Height<>176 then begin
desplegar1.caption:='&Plegar';
SpeedButton3.hint:='Plegar';
form1.Height:=176;
end

else begin
desplegar1.caption:='Des&plegar';
SpeedButton3.hint:='Desplegar';
form1.Height:=panel3.Height+4;
end;

end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
application.Minimize;
end;

procedure TForm1.Image7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
If button=mbRight then begin
minimizar1.Enabled:=true;
desplegar1.enabled:=true;
iconizar1.caption:='&Iconizar';
SiempreVisible1.enabled:=true;
PopupMenu1.Popup(form1.left+2, form1.top+20);
end;

end;

procedure TForm1.Image7Click(Sender: TObject);
begin
abrir.filename:=fichero;
if abrir.execute then begin
fichero:=abrir.filename;
telefonos.free;//cierro el abierto
telefonos:=tinifile.create(fichero);
telefonos.ReadSection('GRUPOS',grupo.items);
grupo.Sorted:=true;
persona.text:='';
end;

end;

procedure TForm1.Panel4Click(Sender: TObject);
begin
if panel4.BevelInner=bvraised then begin
 panel4.BevelInner:=bvlowered;
 form1.formstyle:=fsstayontop;
end
else begin
 panel4.BevelInner:=bvraised;
 form1.formstyle:=fsnormal;
end;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
SiempreVisible1.Checked:=panel4.BevelInner=bvlowered;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
if (uppercase(paramstr(1))='/NOSAVE') or (uppercase(paramstr(2))='/NOSAVE') then toolbutton1.Enabled:=false;
speedbutton1.Enabled:=toolbutton1.Enabled;
toolbutton2.Enabled:=toolbutton1.Enabled;
end;

end.
