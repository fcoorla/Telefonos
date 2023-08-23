unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, StdCtrls,ExtCtrls;

type
  TForm2 = class(TForm)
    lista: TListView;
    ImageList1: TImageList;
    contactos: TListBox;
    aux: TListBox;
    barra: TStatusBar;
    ajuste: TTimer;
    procedure FormShow(Sender: TObject);
    procedure listaColumnClick(Sender: TObject; Column: TListColumn);
    procedure listaCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ajusteTimer(Sender: TObject);
    procedure listaDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ColumnToSort:integer;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm2.FormShow(Sender: TObject);
var
fichero:file of byte;
x:shortint;
tamano:real;

begin
// cargo contactos con las entradas de MOVIL
contactos.clear;
form1.telefonos.ReadSection('MOVIL',contactos.items);

//cargo aux con las enmtradas de CASA
aux.Clear;
form1.telefonos.readsection('CASA',aux.items);
//añado a contactos los que estan en CASA y no en contactos
for x:=0 to aux.items.count-1 do
   if contactos.items.indexof(aux.items[x])=-1 then
      contactos.items.add(aux.items[x]);

//cargo aux con las enmtradas de OFICINA
aux.Clear;
form1.telefonos.readsection('OFICINA',aux.items);
//añado a contactos los que estan en OFICINA y no en contactos
for x:=0 to aux.items.count-1 do
   if contactos.items.indexof(aux.items[x])=-1 then
      contactos.items.add(aux.items[x]);
//aqui ya tengo contactos con todas las entradas de las tres claves
contactos.Sorted:=true;

for x:=0 to contactos.items.count-1 do begin
with lista.items.Add do begin
  SubItems.add(form1.telefonos.readstring('GRUPO',contactos.Items[x],''));
  SubItems.add(form1.telefonos.readstring('MOVIL',contactos.Items[x],''));
  SubItems.add(form1.telefonos.readstring('CASA',contactos.Items[x],''));
  SubItems.add(form1.telefonos.readstring('OFICINA',contactos.Items[x],''));
end;
lista.items[lista.items.count-1].caption:=contactos.Items[x];

if lista.items[lista.items.count-1].subitems[0]='' then lista.items[lista.items.count-1].ImageIndex:=-1
else lista.items[lista.items.count-1].ImageIndex:=form1.telefonos.readinteger('GRUPOS',lista.items[lista.items.count-1].subitems[0],-3)+2;

if form1.ToolButton1.enabled then begin
AssignFile(fichero,form1.fichero);
reset(fichero);
tamano:=filesize(fichero);
CloseFile(fichero);
if tamano<1024 then barra.Panels[0].Text:=inttostr(round(tamano))+' bytes'
else barra.Panels[0].Text:=floattostr(round((tamano/1024)*100)/100)+' KB';
end
else barra.Panels[0].Text:='Solo Lectura';

//cargo aux con las enmtradas de GRUPOS
aux.Clear;
form1.telefonos.readsection('GRUPOS',aux.items);
barra.Panels[1].Text:=inttostr(aux.items.count)+' Grupos';

barra.Panels[2].Text:=inttostr(lista.items.count)+' Contactos';
ajuste.enabled:=true;
end;

end;

procedure TForm2.listaColumnClick(Sender: TObject; Column: TListColumn);
begin
ColumnToSort := Column.Index;
(Sender as TCustomListView).AlphaSort;
end;

procedure TForm2.listaCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;
end;


procedure TForm2.ajusteTimer(Sender: TObject);
begin
ajuste.enabled:=false;
form2.Height:=form2.Height+1;
ajuste.free;
end;

procedure TForm2.listaDblClick(Sender: TObject);
begin
form1.persona.text:=lista.Selected.Caption;
close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
form1.Imagelist1.Geticon(2,form2.icon);
barra.panels[3].text:=extractfilename(form1.fichero);
end;

end.
