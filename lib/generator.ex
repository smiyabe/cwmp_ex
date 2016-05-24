defmodule CWMP.Protocol.Generator do
  import XmlBuilder

  @moduledoc """

  Generates InformResponse XML

  """
  def inform_response(header, resp) do
    envelope(header,CWMP.Protocol.Generator.Messages.InformResponse.generate(resp))
  end

  @moduledoc """

  Generates GetParameterValues XML

  """
  def get_parameter_values(header, req) do
    envelope(header,CWMP.Protocol.Generator.Messages.GetParameterValuesRequest.generate(req))
  end

  @moduledoc """

  Generates SetParameterValues XML

  """
  def set_parameter_values(header, req) do
    envelope(header,CWMP.Protocol.Generator.Messages.SetParameterValuesRequest.generate(req))
  end

  @moduledoc """

  Generates GetRPCMethods XML

  """
  def get_rpc_methods(header) do
    envelope(header,CWMP.Protocol.Generator.Messages.GetRPCMethodsRequest.generate);
  end

  @moduledoc """

  Wraps the SOAP Envelope around the meat of the request

  """
  defp envelope(head,body) do
    header=CWMP.Protocol.Generator.Messages.Header.generate(head)
    element('SOAP-ENV:Envelope',
      %{
        'xmlns:SOAP-ENV': "http://schemas.xmlsoap.org/soap/envelope/",
        'xmlns:SOAP-ENC': "http://schemas.xmlsoap.org/soap/encoding/",
        'xmlns:xsi': "http://www.w3.org/2001/XMLSchema-instance",
        'xmlns:xsd': "http://www.w3.org/2001/XMLSchema",
        'xmlns:cwmp': "urn:dslforum-org:cwmp-1-0"
      },
      [ element('SOAP-ENV:Header', [header]), element('SOAP-ENV:Body', [body]) ] ) |> generate;
  end
end
