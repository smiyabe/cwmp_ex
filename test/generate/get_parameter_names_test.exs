defmodule CWMP.Protocol.Generator.GetParameterNamesTest do
  use ExUnit.Case, async: true

  @sample ~s|<SOAP-ENV:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cwmp="urn:dslforum-org:cwmp-1-4" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <SOAP-ENV:Header>
    <cwmp:ID SOAP-ENV:mustUnderstand="1">API_7bfc27c1f4f0a2c1d775f8aa1840439e</cwmp:ID>
  </SOAP-ENV:Header>
  <SOAP-ENV:Body>
    <cwmp:GetParameterNames>
      <ParameterPath>Device.Test.</ParameterPath>
      <NextLevel>0</NextLevel>
    </cwmp:GetParameterNames>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|

  test "generates GetParameterNames request" do
    assert(CWMP.Protocol.Generator.generate!(
      %CWMP.Protocol.Messages.Header{id: "API_7bfc27c1f4f0a2c1d775f8aa1840439e"},
      %CWMP.Protocol.Messages.GetParameterNames{parameter_path: "Device.Test.", next_level: false}) == @sample)
  end

  @sample2 ~s|<SOAP-ENV:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cwmp="urn:dslforum-org:cwmp-1-4" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <SOAP-ENV:Header>
    <cwmp:ID SOAP-ENV:mustUnderstand="1">API_7bfc27c1f4f0a2c1d775f8aa1840439e</cwmp:ID>
  </SOAP-ENV:Header>
  <SOAP-ENV:Body>
    <cwmp:GetParameterNames>
      <ParameterPath>Device.Test.</ParameterPath>
      <NextLevel>1</NextLevel>
    </cwmp:GetParameterNames>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|

  test "generates 2nd GetParameterNames request" do
    assert(CWMP.Protocol.Generator.generate!(
      %CWMP.Protocol.Messages.Header{id: "API_7bfc27c1f4f0a2c1d775f8aa1840439e"},
      %CWMP.Protocol.Messages.GetParameterNames{parameter_path: "Device.Test.", next_level: true}) == @sample2)
  end
end
