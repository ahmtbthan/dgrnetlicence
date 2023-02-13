unit unLicence;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Client, REST.Types,
  System.JSON, Vcl.ComCtrls, DALoader, UniLoader, Vcl.ExtCtrls, Data.DB,
  DBAccess, Uni, MemDS, UniProvider, PostgreSQLUniProvider;

type
  TfrmLicence = class(TForm)
    Memo1: TMemo;
    lbKontrol: TLabel;
    ProgressBar1: TProgressBar;
    etVeritabaný: TButton;
    lbKod: TLabel;
    DB: TUniConnection;
    Provider: TPostgreSQLUniProvider;
    qLicence: TUniQuery;
    eCompany: TEdit;
    etManuel: TButton;

    procedure etVeritabanýClick(Sender: TObject);
    procedure etManuelClick(Sender: TObject);

  private
  public
    procedure apiSorgu(company_code: string);
  end;

var
  frmLicence: TfrmLicence;
  RESTClient: TRESTClient;
  RESTResponse: TRESTResponse;
  RESTRequest: TRESTRequest;
  result_code, result_description: string;
  aBody: TJSONObject;

implementation

uses REST.HttpClient;
{$R *.dfm}
{ TForm1 }

procedure TfrmLicence.apiSorgu(company_code: string);
begin
  RESTClient := TRESTClient.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  RESTRequest.Method := TRestRequestMethod.rmPOST;
  RESTClient.BaseURL := 'http://localhost:9090/api/GetLicenceInfo';
  aBody := TJSONObject.Create;
  aBody.AddPair('CompanyCode', company_code);
  RESTRequest.AddBody(aBody.ToString, ctAPPLICATION_JSON);
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTRequest.Execute;
  result_code := TJSONObject(RESTResponse.jsonvalue)
    .GetValue('resultCode').ToString;
  result_description := TJSONObject(RESTResponse.jsonvalue)
    .GetValue('resultDesc').ToString;
end;

procedure TfrmLicence.etVeritabanýClick(Sender: TObject);
var
  result_data: TJSONArray;
  data_item: TJsonValue;
  licenceActive: string;
  endDate: string;
begin

  try
    qLicence.Open;
    apiSorgu(qLicence.FieldByName('company_code').AsString);
    if result_code = '"0"' then
    begin
      Memo1.Lines.Add('Baþarýlý: ' + result_code + ' ' + result_description);
      result_data :=
        TJSONArray(TJSONObject.ParseJSONValue
        (TJSONObject(RESTResponse.jsonvalue).GetValue('data').ToString));

      for data_item in result_data do
      begin
        licenceActive := data_item.GetValue<string>('LicenceActive');
        endDate := data_item.GetValue<string>('LicenceEndDate');
        if (licenceActive = 'E') and
          (endDate > FormatDateTime('dd.mm.yyyy', Now)) and
          (endDate = qLicence.FieldByName('end_date').AsString) then
        begin
          ProgressBar1.Position := 1000;
          Memo1.Lines.Add(data_item.GetValue<string>('LicenceActive'));
          Memo1.Lines.Add(data_item.GetValue<string>('LicenceEndDate'));
          lbKontrol.Caption := 'Lisans Doðrulamasý Baþarýlý.';
          lbKontrol.Font.Color := clGreen;
          Application.MessageBox('Lisansýnýz Geçerlidir !', 'Baþarýlý',
            MB_ICONASTERISK);
          qLicence.Close;
          Exit;

        end
        else if (licenceActive = 'H') and
          (endDate < FormatDateTime('dd.mm.yyyy', Now)) and
          (endDate = qLicence.FieldByName('end_date').AsString) then
        begin
          ProgressBar1.Position := 750;
          Memo1.Lines.Add(data_item.GetValue<string>('LicenceActive'));
          Memo1.Lines.Add(data_item.GetValue<string>('LicenceEndDate'));
          lbKontrol.Caption := 'Lisans Süresi Dolmuþ.';
          lbKontrol.Font.Color := clYellow;
          Application.MessageBox
            ('Lisans Süreniz Dolmuþtur Lütfen Tekrar Aktif Ediniz !',
            'Lisans Süresi', MB_ICONWARNING);
          qLicence.Close;
          Application.Terminate;
          Exit;
        end;

      end;

    end
    else if result_code = '"-1"' then
    begin
      ProgressBar1.Position := 250;
      lbKontrol.Caption := 'Lisans Doðrulamasý Baþarýsýz.';
      lbKontrol.Font.Color := clRed;
      Application.MessageBox
        ('Lisans Kodu Bulunamadý Lütfen Ýletiþime Geçiniz !', 'Lisans Hatasý',
        MB_ICONERROR);
      Application.Terminate;
      Exit;
    end;
  except
    on E: Exception do
      if not(E is EHTTPProtocolException) then
      begin
        Application.MessageBox('Baðlantý Kurulamadý !', 'HATA', MB_ICONERROR);
        Application.Terminate;
      end;
  end;
end;

procedure TfrmLicence.etManuelClick(Sender: TObject);
var
  result_data: TJSONArray;
  data_item: TJsonValue;
  licenceActive: string;
  endDate: string;
begin

  try
    qLicence.Open;
    apiSorgu(eCompany.Text);
    if result_code = '"0"' then
    begin
      Memo1.Lines.Add('Baþarýlý: ' + result_code + ' ' + result_description);
      result_data :=
        TJSONArray(TJSONObject.ParseJSONValue
        (TJSONObject(RESTResponse.jsonvalue).GetValue('data').ToString));

      for data_item in result_data do
      begin
        licenceActive := data_item.GetValue<string>('LicenceActive');
        endDate := data_item.GetValue<string>('LicenceEndDate');
        if (licenceActive = 'E') and
          (endDate > FormatDateTime('dd.mm.yyyy', Now)) then
        begin
          ProgressBar1.Position := 1000;
          Memo1.Lines.Add(data_item.GetValue<string>('LicenceActive'));
          Memo1.Lines.Add(data_item.GetValue<string>('LicenceEndDate'));
          lbKontrol.Caption := 'Lisans Doðrulamasý Baþarýlý.';
          lbKontrol.Font.Color := clGreen;
          Application.MessageBox('Lisansýnýz Geçerlidir !', 'Baþarýlý',
            MB_ICONASTERISK);
          qLicence.Close;
          Exit;

        end
        else if (licenceActive = 'H') and
          (endDate < FormatDateTime('dd.mm.yyyy', Now)) then
        begin
          ProgressBar1.Position := 750;
          Memo1.Lines.Add(data_item.GetValue<string>('LicenceActive'));
          Memo1.Lines.Add(data_item.GetValue<string>('LicenceEndDate'));
          lbKontrol.Caption := 'Lisans Süresi Dolmuþ.';
          lbKontrol.Font.Color := $000080FF;
          Application.MessageBox
            ('Lisans süreniz dolmuþtur lütfen tekrar aktif ediniz !',
            'Lisans Süresi', MB_ICONWARNING);
          qLicence.Close;
          Application.Terminate;
          Exit;
        end;

      end;

    end
    else if result_code = '"-1"' then
    begin
      ProgressBar1.Position := 250;
      lbKontrol.Caption := 'Lisans Doðrulamasý Baþarýsýz.';
      lbKontrol.Font.Color := clRed;
      Application.MessageBox('Lisans Kodu Giriniz !', 'HATA', MB_ICONERROR);
      ProgressBar1.Position := 0;
      Exit;
    end;
  except
    on E: Exception do
      if not(E is EHTTPProtocolException) then
      begin
        Application.MessageBox('Baðlantý Kurulamadý !', 'HATA', MB_ICONERROR);
        Application.Terminate;
        Exit;

      end;
  end;
end;

end.
