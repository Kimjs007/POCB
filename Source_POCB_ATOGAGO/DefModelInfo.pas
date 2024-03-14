unit DefModelInfo;

interface
{$I Common.inc}

uses
  System.Classes;
const
  // 변수 타입
  _INTEGER    = 101;
  _FLOAT      = 102;
  _STRING     = 103;

  //
  _FOR       = 201;
  _IF        = 202;
  _CASE      = 203;

  // 제공되는 함수
  ADD        = 301;
  SUB        = 302;
  MULTI      = 303;
  DIVIDE     = 304;
  MODULE     = 305;

  MIN_CMD_NO = ADD;
  MAX_CMD_NO = MODULE;

  crlf : string = #13 + #10;
type
  TInteger = record
    var_name  : string;
    var_value : integer;
  end;

  Tfloat = record
    var_name  : string;
    var_value : Real;
  end;

  TFunctionList = class(TObject)
    function Add(x,y: Integer): Integer;
    function Sub(x,y: Integer): Integer;
    function Multi(x,y: Integer): Integer;
    function Divide(x,y: Integer): Integer;
    function Module(x,y: Integer): Integer;
  end;

var
  LinkedList   : TList;
  List_integer : TList;
  List_float   : TList;
  arr_var      : array of array of String;
  arr_Integer  : array of array of String;
  arr_float    : array of array of String;
  nVarCnt      : integer;

implementation

function TFunctionList.Add(x, y: Integer): Integer;
begin
  Result := x + y;
end;

function TFunctionList.divide(x, y: Integer): Integer;
begin
  Result := x div y;
end;

function TFunctionList.Module(x, y: Integer): Integer;
begin
  Result := x mod y;
end;

function TFunctionList.Multi(x, y: Integer): Integer;
begin
  Result := x * y;
end;

function TFunctionList.Sub(x, y: Integer): Integer;
begin
  Result := x - y;
end;

end.
