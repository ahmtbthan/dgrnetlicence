program Licence;

uses
  Vcl.Forms,
  unLicence in 'unLicence.pas' {frmLicence};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLicence, frmLicence);
  Application.Run;
end.
