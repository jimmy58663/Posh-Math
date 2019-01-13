Function Test-Prime{
<#
.SYNOPSIS
Test if a provided number is prime.

.DESCRIPTION
Returns a Boolean value as to whether the provided number is prime.

.PARAMETER Number
A 64 bit integer that will be tested to determine if it is a prime number.

.EXAMPLE
Test-Prime -Number 147
False

.EXAMPLE
Test-Prime 3
True

.OUTPUTS
[System.Boolean]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
[cmdletbinding()]
param(
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [long]$Number
)
    If ($Number -eq 0 -or $Number -eq 1){
        Return $false
    }
    
    $LowEnd = 2
    $HighEnd = [Math]::Sqrt($Number)

    $IsPrime = $true
    While ($LowEnd -le $HighEnd -and $IsPrime){
        If ($Number % $LowEnd -eq 0){
            $IsPrime = $false
        }
        $LowEnd++
    }
    Write-Output $IsPrime
}
Export-ModuleMember Test-Prime

Function Get-PrimeFactor{
<#
.SYNOPSIS
Get the prime factors of a number.

.DESCRIPTION
Returns an array of integers containing all the prime factors of the provided number.

.PARAMETER Number
A 64 bit integer to which you wish to know the prime factors.

.EXAMPLE
Get-PrimeFactor -Number 147
3
    7
    7

.EXAMPLE
Get-PrimeFactor 20678
2
    7
    7
    211

.OUTPUTS
[System.Array] of [System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [long]$Number
    )
    $Divisor = 2
    $Result = $Number
    $PrimeFactors = New-Object System.Collections.Generic.List[long]
    While ($Result -gt 1){
        If ($Result % $Divisor -eq 0){
            $Result = $Result / $Divisor
            $PrimeFactors.Add($Divisor)
        }
        Else{
            $Divisor++
        }
    }
    Write-Output $PrimeFactors
}
Export-ModuleMember Get-PrimeFactor

Function Get-LeastCommonMultiple{
<#
.SYNOPSIS
Get the least common multiple of provided numbers.

.DESCRIPTION
Returns the least common multiple of the provided numbers.

.PARAMETER Number
An array of 64 bit integers.

.EXAMPLE
Get-LeastCommonMultiple -Number 147, 257
37779

.EXAMPLE
Get-LeastCommonMultiple 147, 20678
62034

.OUTPUTS
[System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [long[]]$Number
    )
    $Collection = New-Object System.Collections.Generic.List[PSObject]
    ForEach ($Entry in $Number){
        $Group = Get-PrimeFactor -Number $Entry | Group-Object
        ForEach ($Item in $Group){
            $Obj = New-Object -TypeName PSObject -Property @{
                Name = $Item.Name;
                Occurrence = $Item.Count
            }
            If ($Obj.Name -in $Collection.Name){
                $Index = $Collection.IndexOf(($Collection | Where-Object {$PSItem.Name -eq $Obj.Name}))
                If ($Obj.Occurrence -gt $Collection[$Index].Occurrence){
                    $Collection[$Index].Occurrence = $Obj.Occurrence
                }
            }
            Else{
                $Collection.Add($Obj)
            }
        }
    }

    $Exponentiation = $Collection | ForEach-Object {
        [Math]::Pow($PSItem.Name,$PSItem.Occurrence)
    }

    $Product = 1
    ForEach ($Entry in $Exponentiation){
        $Product = $Product * $Entry
    }
    $Product = [Convert]::ToInt64($Product, $null)
    Write-Output $Product
}
Export-ModuleMember Get-LeastCommonMultiple

Function Get-SumOfSquare{
<#
.SYNOPSIS
Get the sum of the squares of provided numbers.

.DESCRIPTION
Returns the sum of the square of the provided numbers.

.PARAMETER Number
An array of 64 bit integers.

.EXAMPLE
Get-SumOfSquare -Number 147, 257
87658

.EXAMPLE
Get-SumOfSquare 147, 20678
427601293

.OUTPUTS
[System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [long[]]$Number
    )
    $Total = 0
    ForEach ($Item in $Number){
        $Total += $Item * $Item
    }
    Write-Output $Total
}
Export-ModuleMember Get-SumOfSquare

Function Get-SquareOfSum{
<#
.SYNOPSIS
Get the square of the sum of provided numbers.

.DESCRIPTION
Returns the square of the sum of the provided numbers.

.PARAMETER Number
An array of 64 bit integers.

.EXAMPLE
Get-SquareOfSum -Number 147, 257
163216

.EXAMPLE
Get-SquareOfSum 147, 20678
433680625

.OUTPUTS
[System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [long[]]$Number
    )
    $Total = 0
    ForEach ($Item in $Number){
        $Total += $Item
    }
    $Total = $Total * $Total
    Write-Output $Total
}
Export-ModuleMember Get-SquareOfSum

Function Get-Factor{
<#
.SYNOPSIS
Get all the factors of a number.

.DESCRIPTION
Returns an array of integers containing all the factors of the provided number.

.PARAMETER Number
A 64 bit integer to which you wish to know the factors.

.EXAMPLE
Get-Factor -Number 147
1
    3
    7
    21
    49
    147

.EXAMPLE
Get-Factor 20678
1
    2
    7
    14
    49
    98
    211
    422
    1477
    2954
    10339
    20678

.OUTPUTS
[System.Array] of [System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [long]$Number
    )
    $End = [Math]::Sqrt($Number)
    $Factors = New-Object System.Collections.Generic.List[long]
    For ($Divisor = 2; $Divisor -le $End; $Divisor++){
        If ($Number % $Divisor -eq 0){
            $Result = $Number / $Divisor
            $Factors.Add($Result)
            $Factors.Add($Divisor)
        }
    }

    $Factors.Add(1)
    $Factors.Add($Number)
    $Factors = $Factors | Select-Object -Unique | Sort-Object
    Write-Output $Factors
}
Export-ModuleMember Get-Factor

Function ConvertTo-Binary{
<#
.SYNOPSIS
Converts a base 10 number to binary.

.DESCRIPTION
Converts a base 10 number to binary.

.PARAMETER Number
A base 10 number to change to binary.

.EXAMPLE
ConvertTo-Binary -Number 147
10010101

.EXAMPLE
ConvertTo-Binary 20678
101000101001010

.OUTPUTS
[System.String]

.NOTES
Author: Joshua Chase
Last Modified: 13 Jan 2019
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [long]$Number
    )

    If ($Number -eq 0){
        Return '0'
    }
    Else{
        $AbsoluteValue = [math]::abs($Number)
        $BinaryString = ''
        While ($AbsoluteValue -gt 0){
            $BinaryString = ($AbsoluteValue % 2).ToString() + $BinaryString
            $AbsoluteValue = [int]($AbsoluteValue / 2)
        }
        If ($Number -lt 0){
            $BinaryString = '-' + $BinaryString
        }
        Return $BinaryString
    }
}
Export-ModuleMember -Function ConvertTo-Binary

Function Get-MathCommand{
<#
.SYNOPSIS
Get the commands from Posh-Math.

.DESCRIPTION
Returns the commands in the Posh-Math module.

.PARAMETER Name
A string array that will filter to specific commands based on their name.

.EXAMPLE
Get-MathCommand

.EXAMPLE
Get-MathCommand -Name '*Get*'

.EXAMPLE
Get-MathCommand '*Get*'

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [SupportsWildCards()]
        [String[]]$Name='*'
    )
    Get-Command -Name $Name -Module Posh-Math
}
Export-ModuleMember Get-MathCommand