#Return boolean value as to whether the input is Prime.
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

.EXAMPLE
Test-Prime 147

.OUTPUTS
[System.Boolean]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
[cmdletbinding()]
param(
    [Parameter(Mandatory=$true,Position=0)]
    [long]$Number
)
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

#Return array of the prime factors for the input.
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

.EXAMPLE
Get-PrimeFactor 147

.OUTPUTS
[System.Array] of [System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
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

#Provides the least common multiple for the input.
Function Get-LeastCommonMultiple{
<#
.SYNOPSIS
Get the least common multiple of provided numbers.

.DESCRIPTION
Returns the least common multiple of the provided numbers.

.PARAMETER Numbers
An array of 64 bit integers.

.EXAMPLE
Get-LeastCommonMultiple -Numbers 147, 257

.EXAMPLE
Get-LeastCommonMultiple 147, 257

.OUTPUTS
[System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [long[]]$Numbers
    )
    $Collection = New-Object System.Collections.Generic.List[PSObject]
    ForEach ($Entry in $Numbers){
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

#Provides the sum of all the squares that are input.
Function Get-SumOfSquare{
<#
.SYNOPSIS
Get the sum of the squares of provided numbers.

.DESCRIPTION
Returns the sum of the square of the provided numbers.

.PARAMETER Numbers
An array of 64 bit integers.

.EXAMPLE
Get-SumOfSquare -Numbers 147, 257

.EXAMPLE
Get-SumOfSquare 147, 257

.OUTPUTS
[System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [long[]]$Numbers
    )
    $Total = 0
    ForEach ($Item in $Numbers){
        $Total += $Item * $Item
    }
    Write-Output $Total
}

#Provides the square of the sum of input.
Function Get-SquareOfSum{
<#
.SYNOPSIS
Get the square of the sum of provided numbers.

.DESCRIPTION
Returns the square of the sum of the provided numbers.

.PARAMETER Numbers
An array of 64 bit integers.

.EXAMPLE
Get-SquareOfSum -Numbers 147, 257

.EXAMPLE
Get-SquareOfSum 147, 257

.OUTPUTS
[System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [long[]]$Numbers
    )
    $Total = 0
    ForEach ($Item in $Numbers){
        $Total += $Item
    }
    $Total = $Total * $Total
    Write-Output $Total
}

#Get all factors of a number.
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

.EXAMPLE
Get-Factor 147

.OUTPUTS
[System.Array] of [System.Int64]

.NOTES
Author: Joshua Chase
Last Modified: 19 May 2018
#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
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