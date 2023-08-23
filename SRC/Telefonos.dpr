program Telefonos;

uses
  Forms, Windows, Messages,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

const 
  CM_RESTORE = WM_USER + $1000;

var
RvHandle : hWnd;

{$R *.RES}
begin
  RvHandle := FindWindow('Agenda Telefonos', NIL);
  if RvHandle > 0 then begin
    PostMessage(RvHandle, CM_RESTORE, 0, 0);
    ShowWindow(RvHandle, SW_SHOW);
    Exit;
  end

  else begin
  Application.Initialize;
  Application.Title := 'Agenda Telefonos';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
  end;
end.
