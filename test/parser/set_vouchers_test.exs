defmodule CWMP.Protocol.Parser.SetVouchersTest do
  use ExUnit.Case, async: true

  @sample """
<SOAP-ENV:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cwmp="urn:dslforum-org:cwmp-1-0" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <SOAP-ENV:Header>
    <cwmp:ID SOAP-ENV:mustUnderstand="1">API_69412286f02e475b44783c61972f0a91</cwmp:ID>
  </SOAP-ENV:Header>
  <SOAP-ENV:Body>
    <cwmp:SetVouchers>
      <VoucherList SOAP-ENC:arrayType="base64[1]">
        <base64>PFNpZ25hdHVyZSB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+Cgk8U2lnbmVkSW5mbz4KCQk8Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ii8+CgkJPFNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNkc2Etc2hhMSIvPgoJCTxSZWZlcmVuY2UgVVJJPSIjb3B0aW9uMCI+CgkJCTxUcmFuc2Zvcm1zPgoJCQkJPFRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ij48L1RyYW5zZm9ybT4KCQkJPC9UcmFuc2Zvcm1zPgoJCQk8RGlnZXN0TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI3NoYTEiPjwvRGlnZXN0TWV0aG9kPgoJCQk8RGlnZXN0VmFsdWU+VFV1U3FyMnV0THRRTTV0WTJEQjFqTDNuVjAwPTwvRGlnZXN0VmFsdWU+CgkJPC9SZWZlcmVuY2U+CgkJPFJlZmVyZW5jZSBVUkk9IiNvcHRpb24xIj4KCQkJPFRyYW5zZm9ybXM+CgkJCQk8VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvVFIvMjAwMS9SRUMteG1sLWMxNG4tMjAwMTAzMTUiPjwvVHJhbnNmb3JtPgoJCQk8L1RyYW5zZm9ybXM+CgkJCTxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjc2hhMSI+PC9EaWdlc3RNZXRob2Q+CgkJCTxEaWdlc3RWYWx1ZT4vWVgxQy9FNnpOZjArdzRsRzY2TmVYR09RQjA9PC9EaWdlc3RWYWx1ZT4KCQk8L1JlZmVyZW5jZT4KCTwvU2lnbmVkSW5mbz4KCTxTaWduYXR1cmVWYWx1ZT5LQU1mcU9Tbm1HSDUycVJWR0xORkVFTTRQUGtSU21NVUdyMkQ4RTN2d3dXMjgwZTFCbjVwd1E9PTwvU2lnbmF0dXJlVmFsdWU+Cgk8S2V5SW5mbz4KCQk8S2V5VmFsdWU+CgkJCTxEU0FLZXlWYWx1ZT4KCQkJCTxQPi9YOVRnUjExRWlsUzMwcWNMdXprNS9ZUnQxSTg3MFFBd3g0L2dMWlJKbWxGWFVBaVVmdFpQWTFZK3IvRjlib3c5cwp1YlZXelhnVHVBSFRSdjhtWmd0MnVaVUtXa241L29CSHNRSXNKUHU2blgvcmZHRy9nN1YrZkdxS1lWRHdUN2cvYlQKeFI3REFqVlVFMW9Xa1RMMmRmT3VLMkhYS3UveUlnTVpuZEZJQWNjPTwvUD4KCQkJCTxRPmwyQlFqeFVqQzh5eWtybUNvdXVFQy9CWUhQVT08L1E+CgkJCQk8Rz45K0dnaGRhYlBkN0x2S3RjTnJoWHVYbVVyN3Y2T3VxQytWZE1DejBIZ21kUldWZU91dFJaVCtaeEJ4Q0JnTFJKRm4KRWo2RXdvRmhPM3p3a3lqTWltNFR3V2VvdFVmSTBvNEtPdUhpdXpwbldSYnFOL0Mvb2hOV0x4KzJKNkFTUTd6S1R4CnZxaFJrSW1vZzkvaFd1V2ZCcEtMWmw2QWUxVWxaQUZNTy83UFNTbz08L0c+CgkJCQk8WT5UQkFTQS9takxJOGJjMktNN3U5WDZuSEh2am1QZ1p0VEJocjEvRnpzMkFrZFlDWU13eXkrditPWFU3dTVlMThKdUsKRzcvdW9sVmhqWE5TbjZaZ09iRit3dU1veVAvT1VtTmJTa2ROMWFSWFhIUFJzVzJDY0czdmpmVitDc2cvTFAzemZECnhEa0ltc0M4THVLWGh0L2c0K25rc0EvM2ljUlFYV2FnUUpVOXBVUT08L1k+CgkJCTwvRFNBS2V5VmFsdWU+CgkJPC9LZXlWYWx1ZT4KCQk8WDUwOURhdGE+CgkJCTxYNTA5SXNzdWVyU2VyaWFsPgoJCQkJPFg1MDlJc3N1ZXJOYW1lPkVNQUlMQUREUkVTUz1uYW1lQGV4YW1wbGUuY29tLENOPUV4YW1wbGUsT1U9Q01TLE89RXhhbXBsZSxMPVNhbjIwSm9zZSwgU1Q9Q2FsaWZvcm5pYSxDPVVTPC9YNTA5SXNzdWVyTmFtZT4KCQkJCTxYNTA5U2VyaWFsTnVtYmVyPjQ8L1g1MDlTZXJpYWxOdW1iZXI+CgkJCTwvWDUwOUlzc3VlclNlcmlhbD4KCQkJPFg1MDlTdWJqZWN0TmFtZT5DTj1lbmcuYmJhLmNlcnRzLmV4YW1wbGUuY29tLE9VPUNNUyxPPUV4YW1wbGUsTD1TYW4yMEpvc2UsU1Q9Q0EsQz1VUzwvWDUwOVN1YmplY3ROYW1lPgoJCQk8WDUwOUNlcnRpZmljYXRlPk1JSUVVakNDQTd1Z0F3SUJBZ0lCQkRBTkJna3Foa2lHOXcwQkFRVUZBRENCaERFTE1Ba0dBMVVFQmhNQ1ZWTXhFekFSQmdOVkJBZ1QKQ2tOaGJHbG1iM0p1YVdFeEVUQVBCZ05WQkFjVENGTmhiaUJLYjNObE1RNHdEQVlEVlFRS0V3VXlWMmx5WlRFTU1Bb0dBMVVFQ3hNRApRMDFUTVE0d0RBWURWUVFERXdVeVYybHlaVEVmTUIwR0NTcUdTSWIzRFFFSkFSWVFaV0p5YjNkdVFESjNhWEpsTG1OdmJUQWVGdzB3Ck1qQTVNRFV5TURVNE1UWmFGdzB4TWpBNU1ESXlNRFU0TVRaYU1HMHhDekFKQmdOVkJBWVRBbFZUTVFzd0NRWURWUVFJRXdKRFFURVIKTUE4R0ExVUVCeE1JVTJGdUlFcHZjMlV4RGpBTUJnTlZCQW9UQlRKWGFYSmxNUXd3Q2dZRFZRUUxFd05EVFZNeElEQWVCZ05WQkFNVApGMlZ1Wnk1aVltRXVZMlZ5ZEhNdU1uZHBjbVV1WTI5dE1JSUJ0ekNDQVN3R0J5cUdTTTQ0QkFFd2dnRWZBb0dCQVAxL1U0RWRkUklwClV0OUtuQzdzNU9mMkViZFNQTzlFQU1NZVA0QzJVU1pwUlYxQUlsSDdXVDJOV1BxL3hmVzZNUGJMbTFWczE0RTdnQjAwYi9KbVlMZHIKbVZDbHBKK2Y2QVI3RUNMQ1Q3dXAxLzYzeGh2NE8xZm54cWltRlE4RSs0UDIwOFVld3dJMVZCTmFGcEV5OW5YenJpdGgxeXJ2OGlJRApHWjNSU0FISEFoVUFsMkJRanhVakM4eXlrcm1Db3V1RUMvQllIUFVDZ1lFQTkrR2doZGFiUGQ3THZLdGNOcmhYdVhtVXI3djZPdXFDCitWZE1DejBIZ21kUldWZU91dFJaVCtaeEJ4Q0JnTFJKRm5FajZFd29GaE8zendreWpNaW00VHdXZW90VWZJMG80S091SGl1enBuV1IKYnFOL0Mvb2hOV0x4KzJKNkFTUTd6S1R4dnFoUmtJbW9nOS9oV3VXZkJwS0xabDZBZTFVbFpBRk1PLzdQU1NvRGdZUUFBb0dBVEJBUwpBL21qTEk4YmMyS003dTlYNm5ISHZqbVBnWnRUQmhyMS9GenMyQWtkWUNZTXd5eSt2K09YVTd1NWUxOEp1S0c3L3VvbFZoalhOU242ClpnT2JGK3d1TW95UC9PVW1OYlNrZE4xYVJYWEhQUnNXMkNjRzN2amZWK0NzZy9MUDN6ZkR4RGtJbXNDOEx1S1hodC9nNCtua3NBLzMKaWNSUVhXYWdRSlU5cFVTamdkQXdnYzB3SFFZRFZSME9CQllFRk1UbC9lYmRITGphRW9TUzFQY0xDQWRGWDMycU1JR2JCZ05WSFNNRQpnWk13Z1pDaGdZcWtnWWN3Z1lReEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cFptOXlibWxoTVJFd0R3WURWUVFICkV3aFRZVzRnU205elpURU9NQXdHQTFVRUNoTUZNbGRwY21VeEREQUtCZ05WQkFzVEEwTk5VekVPTUF3R0ExVUVBeE1GTWxkcGNtVXgKSHpBZEJna3Foa2lHOXcwQkNRRVdFR1ZpY205M2JrQXlkMmx5WlM1amIyMkNBUUF3RGdZRFZSMFBBUUgvQkFRREFnZUFNQTBHQ1NxRwpTSWIzRFFFQkJRVUFBNEdCQUYxUEdBYnl2QTBwKzZvN25YZkYzanpBZG9IZGFaaDU1QzhzT1E5SjYySUY4RDFqbDZKeFI3cGpjQ3AyCmlZbVdrd1FNbmNHZnErWDh4UDdCSXFudERtSWxZWHVEVGxYYnl4WHN1NmxuVDduQ2JKd013bExPeEZ3TitBeHk3Qk0zTmtBRkU1TWIKYWFvSld0bUQxUXJ2Y0FGZkRoTGVCVCt0SVJ1ZUs3UHE5TERTPC9YNTA5Q2VydGlmaWNhdGU+CgkJCTxYNTA5Q2VydGlmaWNhdGU+TUlJQ2VUQ0NBZUlDQVFBd0RRWUpLb1pJaHZjTkFRRUVCUUF3Z1lReEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cApabTl5Ym1saE1SRXdEd1lEVlFRSEV3aFRZVzRnU205elpURU9NQXdHQTFVRUNoTUZNbGRwY21VeEREQUtCZ05WQkFzVEEwTk5VekVPCk1Bd0dBMVVFQXhNRk1sZHBjbVV4SHpBZEJna3Foa2lHOXcwQkNRRVdFR1ZpY205M2JrQXlkMmx5WlM1amIyMHdIaGNOTURFd056TXgKTURNd05qUTVXaGNOTURjd01USXhNRE13TmpRNVdqQ0JoREVMTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdQphV0V4RVRBUEJnTlZCQWNUQ0ZOaGJpQktiM05sTVE0d0RBWURWUVFLRXdVeVYybHlaVEVNTUFvR0ExVUVDeE1EUTAxVE1RNHdEQVlEClZRUURFd1V5VjJseVpURWZNQjBHQ1NxR1NJYjNEUUVKQVJZUVpXSnliM2R1UURKM2FYSmxMbU52YlRDQm56QU5CZ2txaGtpRzl3MEIKQVFFRkFBT0JqUUF3Z1lrQ2dZRUExSVNKYkw2aTBKLzZTQm9ldDNhQThma2k4czdwYi9RVVp1ZVdqKzBZS29EYVFXaDRNVUNUMEswNgpOLzBaMmNMTVZnOEp5ZXpFcGRuaDNsVk0vTmk1b3cyTXN0NGRwZGNjUVFFSG91cXdOVVdJQkZVMTk2L0xQUnlMam9NMk5lSVhTS01qCkFkUHd2Y2VueG1xZVZCci9aVW1yNEpRcGRTSTJBWkp1SHZDSWpVc0NBd0VBQVRBTkJna3Foa2lHOXcwQkFRUUZBQU9CZ1FCYTNDQ1gKZ2E5TDBxckdXeHBOajMxMkF6K3RZejhicEVwMmUycEFWckpIZFcvQ0owdVJsRTM0MW9Ua2hmWUZhNUN1dWllRjdKY3dmMUIzK2NHbwpKckxXcWVLcXNObnJibU1GQy85aG5yTGxnWktFS2kwUE9hR1NGUy9Qdzlub2RHV0ZaQ2lhUW1lRytKNkNXZUFTaUZNZHdnUkd2RVNXCmF4Znp6SUtpWHNYd2tBPT08L1g1MDlDZXJ0aWZpY2F0ZT4KCQk8L1g1MDlEYXRhPgoJPC9LZXlJbmZvPgoJPGRzaWc6T2JqZWN0IElkPSIjb3B0aW9uMCIgeG1sbnM9IiIgeG1sbnM6ZHNpZz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+CgkJPE9wdGlvbj4KCQkJPFZTZXJpYWxOdW0+OTg3NjU0MzIxPC9WU2VyaWFsTnVtPgoJCQk8RGV2aWNlSWQ+CgkJCQk8TWFudWZhY3R1cmVyPkV4YW1wbGU8L01hbnVmYWN0dXJlcj4KCQkJCTxPVUk+MDEyMzQ1PC9PVUk+CgkJCQk8UHJvZHVjdENsYXNzPkdhdGV3YXk8L1Byb2R1Y3RDbGFzcz4KCQkJCTxTZXJpYWxOdW1iZXI+MTIzNDU2Nzg5PC9TZXJpYWxOdW1iZXI+CgkJCTwvRGV2aWNlSWQ+CgkJCTxPcHRpb25JZGVudD5GaXJzdCBvcHRpb24gaGVyZTwvT3B0aW9uSWRlbnQ+CgkJCTxPcHRpb25EZXNjPkZpcnN0IG9wdGlvbiBkZXNjcmlwdGlvbjwvT3B0aW9uRGVzYz4KCQkJPFN0YXJ0RGF0ZT4yMDE1LTAxLTE5VDIzOjA4OjI0KzAwOjAwPC9TdGFydERhdGU+CgkJCTxEdXJhdGlvbj4yODA8L0R1cmF0aW9uPgoJCQk8RHVyYXRpb25Vbml0cz5EYXlzPC9EdXJhdGlvblVuaXRzPgoJCQk8TW9kZT5FbmFibGVXaXRoRXhwaXJhdGlvbjwvTW9kZT4KCQk8L09wdGlvbj4KCTwvZHNpZzpPYmplY3Q+Cgk8ZHNpZzpPYmplY3QgSWQ9IiNvcHRpb24xIiB4bWxucz0iIiB4bWxuczpkc2lnPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4KCQk8T3B0aW9uPgoJCQk8VlNlcmlhbE51bT45ODc2NTQzMjE8L1ZTZXJpYWxOdW0+CgkJCTxEZXZpY2VJZD4KCQkJCTxNYW51ZmFjdHVyZXI+RXhhbXBsZTwvTWFudWZhY3R1cmVyPgoJCQkJPE9VST4wMTIzNDU8L09VST4KCQkJCTxQcm9kdWN0Q2xhc3M+R2F0ZXdheTwvUHJvZHVjdENsYXNzPgoJCQkJPFNlcmlhbE51bWJlcj4xMjM0NTY3ODk8L1NlcmlhbE51bWJlcj4KCQkJPC9EZXZpY2VJZD4KCQkJPE9wdGlvbklkZW50PkZpcnN0IG9wdGlvbiBoZXJlPC9PcHRpb25JZGVudD4KCQkJPE9wdGlvbkRlc2M+Rmlyc3Qgb3B0aW9uIGRlc2NyaXB0aW9uPC9PcHRpb25EZXNjPgoJCQk8U3RhcnREYXRlPjIwMTUtMDEtMTlUMjM6MDg6MjQrMDA6MDA8L1N0YXJ0RGF0ZT4KCQkJPER1cmF0aW9uPjI4MDwvRHVyYXRpb24+CgkJCTxEdXJhdGlvblVuaXRzPkRheXM8L0R1cmF0aW9uVW5pdHM+CgkJCTxNb2RlPkVuYWJsZVdpdGhFeHBpcmF0aW9uPC9Nb2RlPgoJCTwvT3B0aW9uPgoJPC9kc2lnOk9iamVjdD4KPC9TaWduYXR1cmU+</base64>
      </VoucherList>
    </cwmp:SetVouchers>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
"""

  @sample_result %{entries: [%CWMP.Protocol.Messages.SetVouchers{
        voucherlist: ["PFNpZ25hdHVyZSB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+Cgk8U2lnbmVkSW5mbz4KCQk8Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ii8+CgkJPFNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNkc2Etc2hhMSIvPgoJCTxSZWZlcmVuY2UgVVJJPSIjb3B0aW9uMCI+CgkJCTxUcmFuc2Zvcm1zPgoJCQkJPFRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ij48L1RyYW5zZm9ybT4KCQkJPC9UcmFuc2Zvcm1zPgoJCQk8RGlnZXN0TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI3NoYTEiPjwvRGlnZXN0TWV0aG9kPgoJCQk8RGlnZXN0VmFsdWU+VFV1U3FyMnV0THRRTTV0WTJEQjFqTDNuVjAwPTwvRGlnZXN0VmFsdWU+CgkJPC9SZWZlcmVuY2U+CgkJPFJlZmVyZW5jZSBVUkk9IiNvcHRpb24xIj4KCQkJPFRyYW5zZm9ybXM+CgkJCQk8VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvVFIvMjAwMS9SRUMteG1sLWMxNG4tMjAwMTAzMTUiPjwvVHJhbnNmb3JtPgoJCQk8L1RyYW5zZm9ybXM+CgkJCTxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjc2hhMSI+PC9EaWdlc3RNZXRob2Q+CgkJCTxEaWdlc3RWYWx1ZT4vWVgxQy9FNnpOZjArdzRsRzY2TmVYR09RQjA9PC9EaWdlc3RWYWx1ZT4KCQk8L1JlZmVyZW5jZT4KCTwvU2lnbmVkSW5mbz4KCTxTaWduYXR1cmVWYWx1ZT5LQU1mcU9Tbm1HSDUycVJWR0xORkVFTTRQUGtSU21NVUdyMkQ4RTN2d3dXMjgwZTFCbjVwd1E9PTwvU2lnbmF0dXJlVmFsdWU+Cgk8S2V5SW5mbz4KCQk8S2V5VmFsdWU+CgkJCTxEU0FLZXlWYWx1ZT4KCQkJCTxQPi9YOVRnUjExRWlsUzMwcWNMdXprNS9ZUnQxSTg3MFFBd3g0L2dMWlJKbWxGWFVBaVVmdFpQWTFZK3IvRjlib3c5cwp1YlZXelhnVHVBSFRSdjhtWmd0MnVaVUtXa241L29CSHNRSXNKUHU2blgvcmZHRy9nN1YrZkdxS1lWRHdUN2cvYlQKeFI3REFqVlVFMW9Xa1RMMmRmT3VLMkhYS3UveUlnTVpuZEZJQWNjPTwvUD4KCQkJCTxRPmwyQlFqeFVqQzh5eWtybUNvdXVFQy9CWUhQVT08L1E+CgkJCQk8Rz45K0dnaGRhYlBkN0x2S3RjTnJoWHVYbVVyN3Y2T3VxQytWZE1DejBIZ21kUldWZU91dFJaVCtaeEJ4Q0JnTFJKRm4KRWo2RXdvRmhPM3p3a3lqTWltNFR3V2VvdFVmSTBvNEtPdUhpdXpwbldSYnFOL0Mvb2hOV0x4KzJKNkFTUTd6S1R4CnZxaFJrSW1vZzkvaFd1V2ZCcEtMWmw2QWUxVWxaQUZNTy83UFNTbz08L0c+CgkJCQk8WT5UQkFTQS9takxJOGJjMktNN3U5WDZuSEh2am1QZ1p0VEJocjEvRnpzMkFrZFlDWU13eXkrditPWFU3dTVlMThKdUsKRzcvdW9sVmhqWE5TbjZaZ09iRit3dU1veVAvT1VtTmJTa2ROMWFSWFhIUFJzVzJDY0czdmpmVitDc2cvTFAzemZECnhEa0ltc0M4THVLWGh0L2c0K25rc0EvM2ljUlFYV2FnUUpVOXBVUT08L1k+CgkJCTwvRFNBS2V5VmFsdWU+CgkJPC9LZXlWYWx1ZT4KCQk8WDUwOURhdGE+CgkJCTxYNTA5SXNzdWVyU2VyaWFsPgoJCQkJPFg1MDlJc3N1ZXJOYW1lPkVNQUlMQUREUkVTUz1uYW1lQGV4YW1wbGUuY29tLENOPUV4YW1wbGUsT1U9Q01TLE89RXhhbXBsZSxMPVNhbjIwSm9zZSwgU1Q9Q2FsaWZvcm5pYSxDPVVTPC9YNTA5SXNzdWVyTmFtZT4KCQkJCTxYNTA5U2VyaWFsTnVtYmVyPjQ8L1g1MDlTZXJpYWxOdW1iZXI+CgkJCTwvWDUwOUlzc3VlclNlcmlhbD4KCQkJPFg1MDlTdWJqZWN0TmFtZT5DTj1lbmcuYmJhLmNlcnRzLmV4YW1wbGUuY29tLE9VPUNNUyxPPUV4YW1wbGUsTD1TYW4yMEpvc2UsU1Q9Q0EsQz1VUzwvWDUwOVN1YmplY3ROYW1lPgoJCQk8WDUwOUNlcnRpZmljYXRlPk1JSUVVakNDQTd1Z0F3SUJBZ0lCQkRBTkJna3Foa2lHOXcwQkFRVUZBRENCaERFTE1Ba0dBMVVFQmhNQ1ZWTXhFekFSQmdOVkJBZ1QKQ2tOaGJHbG1iM0p1YVdFeEVUQVBCZ05WQkFjVENGTmhiaUJLYjNObE1RNHdEQVlEVlFRS0V3VXlWMmx5WlRFTU1Bb0dBMVVFQ3hNRApRMDFUTVE0d0RBWURWUVFERXdVeVYybHlaVEVmTUIwR0NTcUdTSWIzRFFFSkFSWVFaV0p5YjNkdVFESjNhWEpsTG1OdmJUQWVGdzB3Ck1qQTVNRFV5TURVNE1UWmFGdzB4TWpBNU1ESXlNRFU0TVRaYU1HMHhDekFKQmdOVkJBWVRBbFZUTVFzd0NRWURWUVFJRXdKRFFURVIKTUE4R0ExVUVCeE1JVTJGdUlFcHZjMlV4RGpBTUJnTlZCQW9UQlRKWGFYSmxNUXd3Q2dZRFZRUUxFd05EVFZNeElEQWVCZ05WQkFNVApGMlZ1Wnk1aVltRXVZMlZ5ZEhNdU1uZHBjbVV1WTI5dE1JSUJ0ekNDQVN3R0J5cUdTTTQ0QkFFd2dnRWZBb0dCQVAxL1U0RWRkUklwClV0OUtuQzdzNU9mMkViZFNQTzlFQU1NZVA0QzJVU1pwUlYxQUlsSDdXVDJOV1BxL3hmVzZNUGJMbTFWczE0RTdnQjAwYi9KbVlMZHIKbVZDbHBKK2Y2QVI3RUNMQ1Q3dXAxLzYzeGh2NE8xZm54cWltRlE4RSs0UDIwOFVld3dJMVZCTmFGcEV5OW5YenJpdGgxeXJ2OGlJRApHWjNSU0FISEFoVUFsMkJRanhVakM4eXlrcm1Db3V1RUMvQllIUFVDZ1lFQTkrR2doZGFiUGQ3THZLdGNOcmhYdVhtVXI3djZPdXFDCitWZE1DejBIZ21kUldWZU91dFJaVCtaeEJ4Q0JnTFJKRm5FajZFd29GaE8zendreWpNaW00VHdXZW90VWZJMG80S091SGl1enBuV1IKYnFOL0Mvb2hOV0x4KzJKNkFTUTd6S1R4dnFoUmtJbW9nOS9oV3VXZkJwS0xabDZBZTFVbFpBRk1PLzdQU1NvRGdZUUFBb0dBVEJBUwpBL21qTEk4YmMyS003dTlYNm5ISHZqbVBnWnRUQmhyMS9GenMyQWtkWUNZTXd5eSt2K09YVTd1NWUxOEp1S0c3L3VvbFZoalhOU242ClpnT2JGK3d1TW95UC9PVW1OYlNrZE4xYVJYWEhQUnNXMkNjRzN2amZWK0NzZy9MUDN6ZkR4RGtJbXNDOEx1S1hodC9nNCtua3NBLzMKaWNSUVhXYWdRSlU5cFVTamdkQXdnYzB3SFFZRFZSME9CQllFRk1UbC9lYmRITGphRW9TUzFQY0xDQWRGWDMycU1JR2JCZ05WSFNNRQpnWk13Z1pDaGdZcWtnWWN3Z1lReEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cFptOXlibWxoTVJFd0R3WURWUVFICkV3aFRZVzRnU205elpURU9NQXdHQTFVRUNoTUZNbGRwY21VeEREQUtCZ05WQkFzVEEwTk5VekVPTUF3R0ExVUVBeE1GTWxkcGNtVXgKSHpBZEJna3Foa2lHOXcwQkNRRVdFR1ZpY205M2JrQXlkMmx5WlM1amIyMkNBUUF3RGdZRFZSMFBBUUgvQkFRREFnZUFNQTBHQ1NxRwpTSWIzRFFFQkJRVUFBNEdCQUYxUEdBYnl2QTBwKzZvN25YZkYzanpBZG9IZGFaaDU1QzhzT1E5SjYySUY4RDFqbDZKeFI3cGpjQ3AyCmlZbVdrd1FNbmNHZnErWDh4UDdCSXFudERtSWxZWHVEVGxYYnl4WHN1NmxuVDduQ2JKd013bExPeEZ3TitBeHk3Qk0zTmtBRkU1TWIKYWFvSld0bUQxUXJ2Y0FGZkRoTGVCVCt0SVJ1ZUs3UHE5TERTPC9YNTA5Q2VydGlmaWNhdGU+CgkJCTxYNTA5Q2VydGlmaWNhdGU+TUlJQ2VUQ0NBZUlDQVFBd0RRWUpLb1pJaHZjTkFRRUVCUUF3Z1lReEN6QUpCZ05WQkFZVEFsVlRNUk13RVFZRFZRUUlFd3BEWVd4cApabTl5Ym1saE1SRXdEd1lEVlFRSEV3aFRZVzRnU205elpURU9NQXdHQTFVRUNoTUZNbGRwY21VeEREQUtCZ05WQkFzVEEwTk5VekVPCk1Bd0dBMVVFQXhNRk1sZHBjbVV4SHpBZEJna3Foa2lHOXcwQkNRRVdFR1ZpY205M2JrQXlkMmx5WlM1amIyMHdIaGNOTURFd056TXgKTURNd05qUTVXaGNOTURjd01USXhNRE13TmpRNVdqQ0JoREVMTUFrR0ExVUVCaE1DVlZNeEV6QVJCZ05WQkFnVENrTmhiR2xtYjNKdQphV0V4RVRBUEJnTlZCQWNUQ0ZOaGJpQktiM05sTVE0d0RBWURWUVFLRXdVeVYybHlaVEVNTUFvR0ExVUVDeE1EUTAxVE1RNHdEQVlEClZRUURFd1V5VjJseVpURWZNQjBHQ1NxR1NJYjNEUUVKQVJZUVpXSnliM2R1UURKM2FYSmxMbU52YlRDQm56QU5CZ2txaGtpRzl3MEIKQVFFRkFBT0JqUUF3Z1lrQ2dZRUExSVNKYkw2aTBKLzZTQm9ldDNhQThma2k4czdwYi9RVVp1ZVdqKzBZS29EYVFXaDRNVUNUMEswNgpOLzBaMmNMTVZnOEp5ZXpFcGRuaDNsVk0vTmk1b3cyTXN0NGRwZGNjUVFFSG91cXdOVVdJQkZVMTk2L0xQUnlMam9NMk5lSVhTS01qCkFkUHd2Y2VueG1xZVZCci9aVW1yNEpRcGRTSTJBWkp1SHZDSWpVc0NBd0VBQVRBTkJna3Foa2lHOXcwQkFRUUZBQU9CZ1FCYTNDQ1gKZ2E5TDBxckdXeHBOajMxMkF6K3RZejhicEVwMmUycEFWckpIZFcvQ0owdVJsRTM0MW9Ua2hmWUZhNUN1dWllRjdKY3dmMUIzK2NHbwpKckxXcWVLcXNObnJibU1GQy85aG5yTGxnWktFS2kwUE9hR1NGUy9Qdzlub2RHV0ZaQ2lhUW1lRytKNkNXZUFTaUZNZHdnUkd2RVNXCmF4Znp6SUtpWHNYd2tBPT08L1g1MDlDZXJ0aWZpY2F0ZT4KCQk8L1g1MDlEYXRhPgoJPC9LZXlJbmZvPgoJPGRzaWc6T2JqZWN0IElkPSIjb3B0aW9uMCIgeG1sbnM9IiIgeG1sbnM6ZHNpZz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+CgkJPE9wdGlvbj4KCQkJPFZTZXJpYWxOdW0+OTg3NjU0MzIxPC9WU2VyaWFsTnVtPgoJCQk8RGV2aWNlSWQ+CgkJCQk8TWFudWZhY3R1cmVyPkV4YW1wbGU8L01hbnVmYWN0dXJlcj4KCQkJCTxPVUk+MDEyMzQ1PC9PVUk+CgkJCQk8UHJvZHVjdENsYXNzPkdhdGV3YXk8L1Byb2R1Y3RDbGFzcz4KCQkJCTxTZXJpYWxOdW1iZXI+MTIzNDU2Nzg5PC9TZXJpYWxOdW1iZXI+CgkJCTwvRGV2aWNlSWQ+CgkJCTxPcHRpb25JZGVudD5GaXJzdCBvcHRpb24gaGVyZTwvT3B0aW9uSWRlbnQ+CgkJCTxPcHRpb25EZXNjPkZpcnN0IG9wdGlvbiBkZXNjcmlwdGlvbjwvT3B0aW9uRGVzYz4KCQkJPFN0YXJ0RGF0ZT4yMDE1LTAxLTE5VDIzOjA4OjI0KzAwOjAwPC9TdGFydERhdGU+CgkJCTxEdXJhdGlvbj4yODA8L0R1cmF0aW9uPgoJCQk8RHVyYXRpb25Vbml0cz5EYXlzPC9EdXJhdGlvblVuaXRzPgoJCQk8TW9kZT5FbmFibGVXaXRoRXhwaXJhdGlvbjwvTW9kZT4KCQk8L09wdGlvbj4KCTwvZHNpZzpPYmplY3Q+Cgk8ZHNpZzpPYmplY3QgSWQ9IiNvcHRpb24xIiB4bWxucz0iIiB4bWxuczpkc2lnPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4KCQk8T3B0aW9uPgoJCQk8VlNlcmlhbE51bT45ODc2NTQzMjE8L1ZTZXJpYWxOdW0+CgkJCTxEZXZpY2VJZD4KCQkJCTxNYW51ZmFjdHVyZXI+RXhhbXBsZTwvTWFudWZhY3R1cmVyPgoJCQkJPE9VST4wMTIzNDU8L09VST4KCQkJCTxQcm9kdWN0Q2xhc3M+R2F0ZXdheTwvUHJvZHVjdENsYXNzPgoJCQkJPFNlcmlhbE51bWJlcj4xMjM0NTY3ODk8L1NlcmlhbE51bWJlcj4KCQkJPC9EZXZpY2VJZD4KCQkJPE9wdGlvbklkZW50PkZpcnN0IG9wdGlvbiBoZXJlPC9PcHRpb25JZGVudD4KCQkJPE9wdGlvbkRlc2M+Rmlyc3Qgb3B0aW9uIGRlc2NyaXB0aW9uPC9PcHRpb25EZXNjPgoJCQk8U3RhcnREYXRlPjIwMTUtMDEtMTlUMjM6MDg6MjQrMDA6MDA8L1N0YXJ0RGF0ZT4KCQkJPER1cmF0aW9uPjI4MDwvRHVyYXRpb24+CgkJCTxEdXJhdGlvblVuaXRzPkRheXM8L0R1cmF0aW9uVW5pdHM+CgkJCTxNb2RlPkVuYWJsZVdpdGhFeHBpcmF0aW9uPC9Nb2RlPgoJCTwvT3B0aW9uPgoJPC9kc2lnOk9iamVjdD4KPC9TaWduYXR1cmU+"]}],
    header: %CWMP.Protocol.Messages.Header{hold_requests: false, id: "API_69412286f02e475b44783c61972f0a91",
      session_timeout: 30, no_more_requests: false}}

  @sample_xml ~s|<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
\t<SignedInfo>
\t\t<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
\t\t<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#dsa-sha1"/>
\t\t<Reference URI="#option0">
\t\t\t<Transforms>
\t\t\t\t<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></Transform>
\t\t\t</Transforms>
\t\t\t<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></DigestMethod>
\t\t\t<DigestValue>TUuSqr2utLtQM5tY2DB1jL3nV00=</DigestValue>
\t\t</Reference>
\t\t<Reference URI="#option1">
\t\t\t<Transforms>
\t\t\t\t<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></Transform>
\t\t\t</Transforms>
\t\t\t<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></DigestMethod>
\t\t\t<DigestValue>/YX1C/E6zNf0+w4lG66NeXGOQB0=</DigestValue>
\t\t</Reference>
\t</SignedInfo>
\t<SignatureValue>KAMfqOSnmGH52qRVGLNFEEM4PPkRSmMUGr2D8E3vwwW280e1Bn5pwQ==</SignatureValue>
\t<KeyInfo>
\t\t<KeyValue>
\t\t\t<DSAKeyValue>
\t\t\t\t<P>/X9TgR11EilS30qcLuzk5/YRt1I870QAwx4/gLZRJmlFXUAiUftZPY1Y+r/F9bow9s\nubVWzXgTuAHTRv8mZgt2uZUKWkn5/oBHsQIsJPu6nX/rfGG/g7V+fGqKYVDwT7g/bT\nxR7DAjVUE1oWkTL2dfOuK2HXKu/yIgMZndFIAcc=</P>
\t\t\t\t<Q>l2BQjxUjC8yykrmCouuEC/BYHPU=</Q>
\t\t\t\t<G>9+GghdabPd7LvKtcNrhXuXmUr7v6OuqC+VdMCz0HgmdRWVeOutRZT+ZxBxCBgLRJFn\nEj6EwoFhO3zwkyjMim4TwWeotUfI0o4KOuHiuzpnWRbqN/C/ohNWLx+2J6ASQ7zKTx\nvqhRkImog9/hWuWfBpKLZl6Ae1UlZAFMO/7PSSo=</G>
\t\t\t\t<Y>TBASA/mjLI8bc2KM7u9X6nHHvjmPgZtTBhr1/Fzs2AkdYCYMwyy+v+OXU7u5e18JuK\nG7/uolVhjXNSn6ZgObF+wuMoyP/OUmNbSkdN1aRXXHPRsW2CcG3vjfV+Csg/LP3zfD\nxDkImsC8LuKXht/g4+nksA/3icRQXWagQJU9pUQ=</Y>
\t\t\t</DSAKeyValue>
\t\t</KeyValue>
\t\t<X509Data>
\t\t\t<X509IssuerSerial>
\t\t\t\t<X509IssuerName>EMAILADDRESS=name@example.com,CN=Example,OU=CMS,O=Example,L=San20Jose, ST=California,C=US</X509IssuerName>
\t\t\t\t<X509SerialNumber>4</X509SerialNumber>
\t\t\t</X509IssuerSerial>
\t\t\t<X509SubjectName>CN=eng.bba.certs.example.com,OU=CMS,O=Example,L=San20Jose,ST=CA,C=US</X509SubjectName>
\t\t\t<X509Certificate>MIIEUjCCA7ugAwIBAgIBBDANBgkqhkiG9w0BAQUFADCBhDELMAkGA1UEBhMCVVMxEzARBgNVBAgT\nCkNhbGlmb3JuaWExETAPBgNVBAcTCFNhbiBKb3NlMQ4wDAYDVQQKEwUyV2lyZTEMMAoGA1UECxMD
Q01TMQ4wDAYDVQQDEwUyV2lyZTEfMB0GCSqGSIb3DQEJARYQZWJyb3duQDJ3aXJlLmNvbTAeFw0w
MjA5MDUyMDU4MTZaFw0xMjA5MDIyMDU4MTZaMG0xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTER
MA8GA1UEBxMIU2FuIEpvc2UxDjAMBgNVBAoTBTJXaXJlMQwwCgYDVQQLEwNDTVMxIDAeBgNVBAMT
F2VuZy5iYmEuY2VydHMuMndpcmUuY29tMIIBtzCCASwGByqGSM44BAEwggEfAoGBAP1/U4EddRIp
Ut9KnC7s5Of2EbdSPO9EAMMeP4C2USZpRV1AIlH7WT2NWPq/xfW6MPbLm1Vs14E7gB00b/JmYLdr
mVClpJ+f6AR7ECLCT7up1/63xhv4O1fnxqimFQ8E+4P208UewwI1VBNaFpEy9nXzrith1yrv8iID
GZ3RSAHHAhUAl2BQjxUjC8yykrmCouuEC/BYHPUCgYEA9+GghdabPd7LvKtcNrhXuXmUr7v6OuqC
+VdMCz0HgmdRWVeOutRZT+ZxBxCBgLRJFnEj6EwoFhO3zwkyjMim4TwWeotUfI0o4KOuHiuzpnWR
bqN/C/ohNWLx+2J6ASQ7zKTxvqhRkImog9/hWuWfBpKLZl6Ae1UlZAFMO/7PSSoDgYQAAoGATBAS
A/mjLI8bc2KM7u9X6nHHvjmPgZtTBhr1/Fzs2AkdYCYMwyy+v+OXU7u5e18JuKG7/uolVhjXNSn6
ZgObF+wuMoyP/OUmNbSkdN1aRXXHPRsW2CcG3vjfV+Csg/LP3zfDxDkImsC8LuKXht/g4+nksA/3
icRQXWagQJU9pUSjgdAwgc0wHQYDVR0OBBYEFMTl/ebdHLjaEoSS1PcLCAdFX32qMIGbBgNVHSME
gZMwgZChgYqkgYcwgYQxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMREwDwYDVQQH
EwhTYW4gSm9zZTEOMAwGA1UEChMFMldpcmUxDDAKBgNVBAsTA0NNUzEOMAwGA1UEAxMFMldpcmUx
HzAdBgkqhkiG9w0BCQEWEGVicm93bkAyd2lyZS5jb22CAQAwDgYDVR0PAQH/BAQDAgeAMA0GCSqG
SIb3DQEBBQUAA4GBAF1PGAbyvA0p+6o7nXfF3jzAdoHdaZh55C8sOQ9J62IF8D1jl6JxR7pjcCp2
iYmWkwQMncGfq+X8xP7BIqntDmIlYXuDTlXbyxXsu6lnT7nCbJwMwlLOxFwN+Axy7BM3NkAFE5Mb
aaoJWtmD1QrvcAFfDhLeBT+tIRueK7Pq9LDS</X509Certificate>
\t\t\t<X509Certificate>MIICeTCCAeICAQAwDQYJKoZIhvcNAQEEBQAwgYQxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxp
Zm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEOMAwGA1UEChMFMldpcmUxDDAKBgNVBAsTA0NNUzEO
MAwGA1UEAxMFMldpcmUxHzAdBgkqhkiG9w0BCQEWEGVicm93bkAyd2lyZS5jb20wHhcNMDEwNzMx
MDMwNjQ5WhcNMDcwMTIxMDMwNjQ5WjCBhDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3Ju
aWExETAPBgNVBAcTCFNhbiBKb3NlMQ4wDAYDVQQKEwUyV2lyZTEMMAoGA1UECxMDQ01TMQ4wDAYD
VQQDEwUyV2lyZTEfMB0GCSqGSIb3DQEJARYQZWJyb3duQDJ3aXJlLmNvbTCBnzANBgkqhkiG9w0B
AQEFAAOBjQAwgYkCgYEA1ISJbL6i0J/6SBoet3aA8fki8s7pb/QUZueWj+0YKoDaQWh4MUCT0K06
N/0Z2cLMVg8JyezEpdnh3lVM/Ni5ow2Mst4dpdccQQEHouqwNUWIBFU196/LPRyLjoM2NeIXSKMj
AdPwvcenxmqeVBr/ZUmr4JQpdSI2AZJuHvCIjUsCAwEAATANBgkqhkiG9w0BAQQFAAOBgQBa3CCX
ga9L0qrGWxpNj312Az+tYz8bpEp2e2pAVrJHdW/CJ0uRlE341oTkhfYFa5CuuieF7Jcwf1B3+cGo
JrLWqeKqsNnrbmMFC/9hnrLlgZKEKi0POaGSFS/Pw9nodGWFZCiaQmeG+J6CWeASiFMdwgRGvESW
axfzzIKiXsXwkA==</X509Certificate>
\t\t</X509Data>
\t</KeyInfo>
\t<dsig:Object Id="#option0" xmlns="" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#">
\t\t<Option>
\t\t\t<VSerialNum>987654321</VSerialNum>
\t\t\t<DeviceId>
\t\t\t\t<Manufacturer>Example</Manufacturer>
\t\t\t\t<OUI>012345</OUI>
\t\t\t\t<ProductClass>Gateway</ProductClass>
\t\t\t\t<SerialNumber>123456789</SerialNumber>
\t\t\t</DeviceId>
\t\t\t<OptionIdent>First option here</OptionIdent>
\t\t\t<OptionDesc>First option description</OptionDesc>
\t\t\t<StartDate>2015-01-19T23:08:24+00:00</StartDate>
\t\t\t<Duration>280</Duration>
\t\t\t<DurationUnits>Days</DurationUnits>
\t\t\t<Mode>EnableWithExpiration</Mode>
\t\t</Option>
\t</dsig:Object>
\t<dsig:Object Id="#option1" xmlns="" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#">
\t\t<Option>
\t\t\t<VSerialNum>987654321</VSerialNum>
\t\t\t<DeviceId>
\t\t\t\t<Manufacturer>Example</Manufacturer>
\t\t\t\t<OUI>012345</OUI>
\t\t\t\t<ProductClass>Gateway</ProductClass>
\t\t\t\t<SerialNumber>123456789</SerialNumber>
\t\t\t</DeviceId>
\t\t\t<OptionIdent>First option here</OptionIdent>
\t\t\t<OptionDesc>First option description</OptionDesc>
\t\t\t<StartDate>2015-01-19T23:08:24+00:00</StartDate>
\t\t\t<Duration>280</Duration>
\t\t\t<DurationUnits>Days</DurationUnits>
\t\t\t<Mode>EnableWithExpiration</Mode>
\t\t</Option>
\t</dsig:Object>
</Signature>|

  test "parses SetVouchers request" do
    parseresult=CWMP.Protocol.Parser.parse(@sample)
    assert(parseresult == @sample_result)

    {:ok,xml}=Base.decode64(hd(hd(parseresult.entries).voucherlist))
    assert(xml == @sample_xml)
  end

end