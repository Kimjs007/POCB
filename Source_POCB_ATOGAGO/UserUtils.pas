unit UserUtils;

interface

uses
  System.Classes, System.SysUtils, IdGlobal, Winapi.Windows, Generics.Collections;

function Equal(arr_a : TIdBytes; nIndex_a : Integer; arr_b : TIdBytes;
                                nIndex_b, nLength: Integer) : Boolean; overload;
function Equal(arr_a : array of byte; nIndex_a : Integer; arr_b : array of byte;
                                nIndex_b, nLength: Integer) : Boolean; overload;

procedure ClearDataBuf(arrBuf : array of byte; nLen : Integer);

function Hex2String(arrHex : TIdBytes) : string; overload;
function Hex2String(arrHex : array of Byte; nLen : Integer) : string; overload;

function TernaryOp(bCondition : Boolean; arrTrue, arrFalse : TIdBytes) : TIdBytes; overload;
function TernaryOp(bCondition : Boolean; sTrue, sFalse : string) : string;   overload;
function TernaryOp(bCondition : Boolean; dTrue, dFalse : Double) : Double;   overload;
function TernaryOp(bCondition : Boolean; dTrue, dFalse : DWORD) : DWORD;   overload;
function TernaryOp(bCondition : Boolean; wTrue, wFalse : Word) : Word; overload;
function TernaryOp(bCondition : Boolean; nTrue, nFalse : Integer) : Integer; overload;
function TernaryOp(bCondition : Boolean; wTrue, wFalse : Byte) : Byte; overload;
function TernaryOp(bCondition : Boolean; bTrue, bFalse : Boolean) : Boolean; overload;

function Sum(const list : TList<Integer>) : Integer;
function GetItemCount(const list : TList<Integer>; nValue : Integer) : Integer;
function RetryFunc(func : TFunc<Boolean>; nTryCnt : Integer; nDelay : Integer = 100) : Boolean;overload;
function ToString(arrStr : array of string; seper : char) : string;
function IncNum(var nNum : Integer; nInc : Integer) : Integer;

implementation

function Equal(arr_a : TIdBytes; nIndex_a : Integer; arr_b : TIdBytes;
                                nIndex_b, nLength: Integer): Boolean;
var
  n : Integer;
begin
  //Dynamic Array에 메모리 할당하고 하는거보다 코드 중복이라도 그대로 쓰는게 이득이라 판단
  if Length(arr_a) < (nIndex_a + nLength) then Exit(False);
  if Length(arr_b) < (nIndex_b + nLength) then Exit(False);

  for n := 0 to Pred(nLength) do
      if arr_a[nIndex_a + n] <> arr_b[nIndex_b + n] then Exit(False);

  Exit(True)
end;

function Equal(arr_a : array of byte; nIndex_a : Integer; arr_b : array of byte;
                                nIndex_b, nLength: Integer) : Boolean;
var
  n : Integer;
begin
  if Length(arr_a) < (nIndex_a + nLength) then Exit(False);
  if Length(arr_b) < (nIndex_b + nLength) then Exit(False);

  for n := 0 to Pred(nLength) do
      if arr_a[nIndex_a + n] <> arr_b[nIndex_b + n] then Exit(False);

  Exit(True)
end;

procedure ClearDataBuf(arrBuf : array of byte; nLen : Integer);
var
  nIndex : Integer;
begin
  for nIndex := 0 to Pred(nLen) do
    arrBuf[nIndex] := 0;
end;

function Hex2String(arrHex : TIdBytes) : string;
var
  sTemp : string;
  nIndex : Integer;
begin
  sTemp := '';

  for nIndex := 0 to Pred(Length(arrHex)) do
    sTemp := sTemp + Format('%0.2x ',[arrHex[nIndex]]);

  Result := sTemp;
end;

function Hex2String(arrHex : array of Byte; nLen : Integer) : string;
var
  sTemp : string;
  nIndex : Integer;
begin
  sTemp := '';

  for nIndex := 0 to Pred(nLen) do
    sTemp := sTemp + Format('%0.2x ',[arrHex[nIndex]]);

  Result := sTemp;
end;

function TernaryOp(bCondition : Boolean; arrTrue, arrFalse : TIdBytes) : TIdBytes;
begin
  if bCondition then Result := arrTrue
  else Result := arrFalse;
end;
function TernaryOp(bCondition : Boolean; sTrue, sFalse : string): string;
begin
  if bCondition then Result := sTrue
  else Result := sFalse;
end;
function TernaryOp(bCondition : Boolean; dTrue, dFalse : Double): Double;
begin
  if bCondition then Result := dTrue
  else Result := dFalse;
end;
function TernaryOp(bCondition : Boolean; dTrue, dFalse : DWORD): DWORD;
begin
  if bCondition then Result := dTrue
  else Result := dFalse;
end;
function TernaryOp(bCondition : Boolean; nTrue, nFalse : Integer): Integer;
begin
  if bCondition then Result := nTrue
  else Result := nFalse;
end;
function TernaryOp(bCondition : Boolean; bTrue, bFalse : Boolean) : Boolean;
begin
  if bCondition then Result := bTrue
  else Result := bFalse;
end;
function TernaryOp(bCondition : Boolean; wTrue, wFalse : Word): Word;
begin
  if bCondition then Result := wTrue
  else Result := wFalse;
end;
function TernaryOp(bCondition : Boolean; wTrue, wFalse : Byte): Byte;
begin
  if bCondition then Result := wTrue
  else Result := wFalse;
end;

function Sum(const list : TList<Integer>) : Integer;
var
  i, nSum    : Integer;
begin
  nSum := 0;

  for i := 0 to Pred(list.Count) do
    nSum := nSum + list[i];

  Result := nSum;
end;

function GetItemCount(const list : TList<Integer>; nValue : Integer) : Integer;
var
  i, nCount : Integer;
begin
  nCount := 0;
  for i := 0 to Pred(list.Count) do
    if list[i] = nValue then Inc(nCount);
    
  Result := nCount;
end;

function RetryFunc(func : TFunc<Boolean>; nTryCnt, nDelay : Integer) : Boolean;
var
  nCnt : Integer;
begin
  if func then Exit(True);
  for nCnt := 0 to Pred(nTryCnt) do begin
    Sleep(nDelay);
	if func then Exit(True);
  end;
  Result := False;
end;

function ToString(arrStr : array of string; seper : char) : string;
var
  sTemp : string;
  nIdx  : Integer;
begin
  sTemp := '';
  for nIdx := 0 to High(arrStr) do
    sTemp := sTemp + arrStr[nIdx] + seper;

  Result := sTemp.Trim([seper]);
end;

//Inc after Call
function IncNum(var nNum : Integer; nInc : Integer) : Integer;
begin
  Result := nNum;
  nNum := nNum + nInc;
end;

end.
