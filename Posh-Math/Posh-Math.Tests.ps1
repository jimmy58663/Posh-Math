Remove-Module Posh-Math -Force
Import-Module "$PSScriptRoot\Posh-Math.psm1"

InModuleScope Posh-Math{
    Describe 'Test-Prime'{
        It 'Returns the proper boolean'{
            Test-Prime -Number 1 | Should be $true
            Test-Prime -Number 2 | Should be $true
            Test-Prime -Number 3 | Should be $true
            Test-Prime -Number 4 | Should be $false
            Test-Prime -Number 147 | Should be $false
            Test-Prime -Number 15485862 | Should be $false
            Test-Prime -Number 15485863 | Should be $true
        }
    }

    Describe 'Get-PrimeFactor'{
        It 'Returns the proper prime factors'{
            Get-PrimeFactor -Number 147 | Should be 3, 7, 7
            Get-PrimeFactor -Number 20678 | Should be 2, 7, 7, 211
            Get-PrimeFactor -Number 287364 | Should be 2, 2, 3, 7, 11, 311
        }
    }

    Describe 'Get-LeastCommonMultiple'{
        It 'Returns the proper LCM'{
            Function Fake-GetPrimeFactor{
                [cmdletbinding()]
                param(
                    [long]$Number
                )
                If ($Number -eq 147){
                    Return 3, 7, 7
                }
                ElseIf ($Number -eq 257){
                    Return 257
                }
                ElseIf ($Number -eq 20678){
                    Return 2, 7, 7, 211
                }
            }

            Mock Get-PrimeFactor{
                Fake-GetPrimeFactor -Number $Entry
            }

            Get-LeastCommonMultiple -Number 147, 257 | Should be 37779
            Get-LeastCommonMultiple -Number 147, 20678 | Should be 62034

            Assert-MockCalled -CommandName Get-PrimeFactor -Scope It -Times 2 -ParameterFilter {$Number -eq 147}
            Assert-MockCalled -CommandName Get-PrimeFactor -Scope It -Times 1 -ParameterFilter {$Number -eq 257}
            Assert-MockCalled -CommandName Get-PrimeFactor -Scope It -Times 1 -ParameterFilter {$Number -eq 20678}
        }
    }

    Describe 'Get-SumOfSquare'{
        It 'Returns proper sum'{
            Get-SumOfSquare -Number 147, 257 | Should be 87658
            Get-SumOfSquare -Number 147, 20678 | Should be 427601293
        }
    }

    Describe 'Get-SquareOfSum'{
        It 'Returns proper square'{
            Get-SquareOfSum -Number 147, 257 | Should be 163216
            Get-SquareOfSum -Number 147, 20678 | Should be 433680625
        }
    }

    Describe 'Get-Factor'{
        It 'Returns proper factors'{
            Get-Factor 9 | Should be 1, 3, 9
            Get-Factor 147 | Should be 1, 3, 7, 21, 49, 147
            Get-Factor 20678 | Should be 1, 2, 7, 14, 49, 98, 211, 422, 1477, 2954, 10339, 20678
        }
    }
    
    Describe 'ConvertTo-Binary'{
        It 'Returns proper binary'{
            ConvertTo-Binary 0 | Should be '0'
            ConvertTo-Binary 9 | Should be '1001'
            ConvertTo-Binary 147 | Should be '10010101'
            ConvertTo-Binary 20678 | Should be '101000101001010'
        }
    }

    Describe 'Get-MathCommand'{
        It 'Returns proper commands'{
            Get-MathCommand | Select-Object -ExpandProperty Name | Should be 'Get-Factor', 'Get-LeastCommonMultiple', 'Get-MathCommand', 'Get-PrimeFactor', 'Get-SquareOfSum', 'Get-SumOfSquare', 'Test-Prime', 'ConvertTo-Binary'
            Get-MathCommand -Name '*Test*' | Select-Object -ExpandProperty Name | Should be 'Test-Prime'
        }
    }
}