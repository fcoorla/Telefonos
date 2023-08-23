unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ToolWin;

type
  TForm3 = class(TForm)
    Image1: TImage;
    grupo: TComboBox;
    Panel2: TPanel;
    Panel1: TPanel;
    icono: TImage;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    aux: TListBox;
    ButtonUp: TButton;
    ButtonDown: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure grupoChange(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure grupoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    indice:Smallint; // el indice de la imagen del grupo

  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses unit1;

{$R *.DFM}

procedure TForm3.FormCreate(Sender: TObject);
begin
indice:=-1;
form1.telefonos.ReadSection('GRUPOS',grupo.items);
end;

procedure TForm3.SpinButton1DownClick(Sender: TObject);
begin
if indice=-1 then indice:=form1.imagelist1.count-1
else indice:=indice-1;
if indice < 3 then indice:=form1.imagelist1.count-1;
form1.ImageList1.Geticon(indice,icono.Picture.Icon);
end;

procedure TForm3.SpinButton1UpClick(Sender: TObject);

begin
if indice=-1 then indice:=3
else indice:=indice+1;
if indice > form1.imagelist1.count-1 then indice:=3;
form1.ImageList1.Geticon(indice,icono.Picture.Icon);
end;

procedure TForm3.ToolButton1Click(Sender: TObject);
begin
form1.telefonos.writeinteger('GRUPOS',grupo.Text,indice);
end;

procedure TForm3.grupoChange(Sender: TObject);
begin
if grupo.text='' then indice:=-1
else indice:=form1.telefonos.ReadInteger('GRUPOS',grupo.text,length(grupo.text)+70);
form1.ImageList1.Geticon(indice,icono.Picture.Icon);
end;

procedure TForm3.ToolButton2Click(Sender: TObject);
var
x:word;

begin
if grupo.text='' then exit;
if application.MessageBox('¿Seguro que quieres Borrar el Grupo?','Agenda Telefonos',mb_okcancel+mb_iconexclamation)=id_ok then begin
form1.telefonos.DeleteKey('GRUPOS',grupo.text);
form1.telefonos.readsection('GRUPO',aux.items);
for x:=0 to aux.items.count-1 do
  if form1.telefonos.readstring('GRUPO',aux.items[x],'')=grupo.text then
    form1.telefonos.deletekey('GRUPO',aux.items[x]);
grupo.text:='';
form1.ImageList1.Geticon(-1,icono.Picture.Icon);
end;

end;

procedure TForm3.grupoKeyPress(Sender: TObject; var Key: Char);
begin
if key in ['=','[',']'] then key:=chr(0);
end;

end.
