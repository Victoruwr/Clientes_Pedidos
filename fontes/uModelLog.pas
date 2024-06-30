
unit uModelLog;

interface
 uses
 System.SysUtils,
 System.Classes,
 Forms;

 type
  TModelLog = class
   private
    FTextLogDefault: text;
    FPathlogFileDefault: string;
   class procedure ReleaseInstance();
   class var F_Instance :  TModelLog;
   public
     constructor create;
     destructor Destroy; override;
     function  Gravarlog(value :string):boolean; overload;
     class function Gravarlog(value :string;pathArquivo:string):TModelLog;  overload;
     class function GetInstance():TModelLog;
     property TextLogDefault: text read FTextLogDefault ;
     property PathlogFileDefault: string read FPathlogFileDefault;

  end;
implementation

uses
  Vcl.Dialogs;

{ TLog }

constructor TModelLog.create;
begin
  FPathlogFileDefault := ExtractFilePath(ParamStr(0))+Application.Title+'_'+FormatDateTime('DD-MM-YYY',Now)+'.log';
end;

destructor TModelLog.Destroy;
begin
  inherited;
end;


function TModelLog.Gravarlog(value: string): boolean;
begin
  Result := true;
  try
    AssignFile(TextLogDefault, FPathlogFileDefault);

    if FileExists(FPathlogFileDefault)
       then Append(TextLogDefault)
       else Rewrite(TextLogDefault);

    if value = sLineBreak
       then  Writeln(TextLogDefault, Value)
       else Writeln(TextLogDefault, FormatDateTime('DD/MM/YY hh:mm:ss', Now)+' - '+Value);

    CloseFile(TextLogDefault);
  except
    Result:=false;
    raise Exception.Create('Não foi possível inserir log no sistema!');
  end;
end;

class function TModelLog.GetInstance: TModelLog;
begin
  if not Assigned(F_Instance)
     then F_Instance := self.create;
  Result :=  F_Instance;
end;

class function TModelLog.Gravarlog(value, pathArquivo: string): TModelLog;
var FPathlogFile:string;
 FTextLog: text;
begin
  Result:= GetInstance;
  FPathlogFile:= pathArquivo;
  try
    AssignFile(FTextLog, FPathlogFile);

    if FileExists(FPathlogFile)
       then Append(FTextlog)
       else Rewrite(FTextlog);

    if value = sLineBreak
       then  Writeln(FTextlog, Value)
       else Writeln(FTextlog, FormatDateTime('DD/MM/YY hh:mm:ss', Now)+' - '+Value);

    CloseFile(FTextlog);
  except
    raise Exception.Create('Não foi possível inserir log no sistema!');
  end;

end;


class procedure TModelLog.ReleaseInstance;
begin
  if Assigned(Self.F_Instance)
     then Self.F_Instance.Free;
end;

Initialization
Finalization
  TModelLog.ReleaseInstance;

end.

