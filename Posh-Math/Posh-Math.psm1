#Return boolean value as to whether the input is Prime.
Function Test-Prime{
[cmdletbinding()]
param(
    [Parameter(Mandatory=$true,Position=0)]
    [int]$Number
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
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [long]$Number
    )
    $Divisor = 2
    $Result = $Number
    $PrimeFactors = New-Object System.Collections.Generic.List[int]
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
    Write-Output $Product
}

#Provides the sum of all the squares that are input.
Function Get-SumOfSquare{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [int[]]$Numbers
    )
    $Total = 0
    ForEach ($Item in $Numbers){
        $Total += $Item * $Item
    }
    Write-Output $Total
}

#Provides the square of the sum of input.
Function Get-SquareOfSum{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [int[]]$Numbers
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
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)]
        [long]$Number
    )
    $Divisor = 2
    $Count = 1
    $Result = $Number
    $Factors = New-Object System.Collections.Generic.List[int]
    While ($Result -gt 1){
        If ($Result % $Divisor -eq 0){
            $Result = $Result / $Divisor
            $Factors.Add([Math]::Pow($Divisor, $Count))
            $Factors.Add($Result)
            $Count++
        }
        Else{
            $Divisor++
            $Count = 1
        }
    }


    $Factors.Add(1)
    $Factors.Add($Number)
    $Factors = $Factors | Sort-Object
    Write-Output $Factors
}