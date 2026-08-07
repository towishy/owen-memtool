Set-StrictMode -Version 2.0

function ConvertTo-ByteSize {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [double]$Bytes
    )

    if ($Bytes -ge 1TB) { return ('{0:N2} TB' -f ($Bytes / 1TB)) }
    if ($Bytes -ge 1GB) { return ('{0:N2} GB' -f ($Bytes / 1GB)) }
    if ($Bytes -ge 1MB) { return ('{0:N1} MB' -f ($Bytes / 1MB)) }
    if ($Bytes -ge 1KB) { return ('{0:N1} KB' -f ($Bytes / 1KB)) }
    return ('{0:N0} B' -f $Bytes)
}

function New-MemoryFinding {
    param(
        [string]$Id,
        [ValidateSet('Critical', 'Warning', 'Info')]
        [string]$Severity,
        [ValidateSet('Observed', 'Suspected', 'Probable', 'Confirmed')]
        [string]$Confidence,
        [string]$Category,
        [string]$Title,
        [string]$Summary,
        [string[]]$Evidence,
        [string[]]$NextSteps,
        [object[]]$RelatedDrivers = @(),
        [int]$Score
    )

    [pscustomobject]@{
        Id         = $Id
        Severity   = $Severity
        Confidence = $Confidence
        Category   = $Category
        Title      = $Title
        Summary    = $Summary
        Evidence   = @($Evidence)
        NextSteps  = @($NextSteps)
        RelatedDrivers = @($RelatedDrivers)
        Score      = $Score
    }
}

function Get-PropertyValue {
    param(
        [AllowNull()]
        [object]$InputObject,
        [string]$Name,
        $DefaultValue = $null
    )

    if ($null -eq $InputObject) { return $DefaultValue }
    $property = $InputObject.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) { return $DefaultValue }
    return $property.Value
}

function Get-MemoryAssessment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$Snapshot
    )

    $findings = New-Object System.Collections.Generic.List[object]
    $physicalBytes = [double](Get-PropertyValue $Snapshot.Computer 'PhysicalMemoryBytes' 0)
    $usedBytes = [double](Get-PropertyValue $Snapshot.Memory 'UsedPhysicalMemoryBytes' 0)
    $availableBytes = [double](Get-PropertyValue $Snapshot.Memory 'AvailablePhysicalMemoryBytes' 0)
    $nonPagedBytes = [double](Get-PropertyValue $Snapshot.Memory 'NonPagedPoolBytes' 0)
    $pagedBytes = [double](Get-PropertyValue $Snapshot.Memory 'PagedPoolBytes' 0)
    $commitBytes = [double](Get-PropertyValue $Snapshot.Memory 'CommitBytes' 0)
    $commitLimitBytes = [double](Get-PropertyValue $Snapshot.Memory 'CommitLimitBytes' 0)
    $processWorkingSetBytes = [double](Get-PropertyValue $Snapshot.Processes 'TotalWorkingSetBytes' 0)
    $durationSeconds = [double](Get-PropertyValue $Snapshot.Trend 'DurationSeconds' 0)
    $nonPagedDeltaBytes = [double](Get-PropertyValue $Snapshot.Trend 'NonPagedPoolDeltaBytes' 0)
    $dwmPrivateBytes = [double](Get-PropertyValue $Snapshot.Dwm 'PrivateBytes' 0)
    $activeDisplays = [int](Get-PropertyValue $Snapshot.Gpu 'ActiveDisplayCount' 0)
    $gpuAdapterCount = @((Get-PropertyValue $Snapshot.Gpu 'Adapters' @())).Count
    $gpuSharedBytes = [double](Get-PropertyValue $Snapshot.Gpu 'SharedUsageBytes' 0)
    $interruptPercent = [double](Get-PropertyValue $Snapshot.Cpu 'InterruptTimePercent' 0)
    $dpcPercent = [double](Get-PropertyValue $Snapshot.Cpu 'DpcTimePercent' 0)
    $interruptsPerSecond = [double](Get-PropertyValue $Snapshot.Cpu 'InterruptsPerSecond' 0)
    $dpcRate = [double](Get-PropertyValue $Snapshot.Cpu 'DpcRate' 0)
    $handleCount = [double](Get-PropertyValue $Snapshot.Handles 'TotalCount' 0)
    $handleDelta = [double](Get-PropertyValue $Snapshot.Handles 'Delta' 0)
    $topHandleGrowth = @((Get-PropertyValue $Snapshot.Handles 'TopGrowth' @()))

    $availableRatio = if ($physicalBytes -gt 0) { $availableBytes / $physicalBytes } else { 1 }
    $commitRatio = if ($commitLimitBytes -gt 0) { $commitBytes / $commitLimitBytes } else { 0 }
    $nonPagedWarning = [Math]::Max(1.5GB, $physicalBytes * 0.05)
    $nonPagedCritical = [Math]::Max(3GB, $physicalBytes * 0.10)
    $pagedWarning = [Math]::Max(2GB, $physicalBytes * 0.08)
    $nonPagedGrowthPerMinute = if ($durationSeconds -ge 60) { $nonPagedDeltaBytes / ($durationSeconds / 60) } else { 0 }
    $sustainedPoolGrowth = $durationSeconds -ge 300 -and $nonPagedDeltaBytes -ge 64MB -and $nonPagedGrowthPerMinute -ge 5MB
    $sustainedHandleGrowth = $durationSeconds -ge 300 -and $handleDelta -ge 5000

    if ($commitRatio -ge 0.90) {
        $findings.Add((New-MemoryFinding -Id 'commit-critical' -Severity 'Critical' -Confidence 'Observed' -Category 'Memory pressure' -Title '커밋 한계에 근접했습니다' -Summary '프로그램과 커널이 약속한 메모리가 시스템 커밋 한계의 90%를 넘었습니다.' -Evidence @(
            ('현재 커밋: {0}' -f (ConvertTo-ByteSize $commitBytes)),
            ('커밋 한계: {0} ({1:P0})' -f (ConvertTo-ByteSize $commitLimitBytes), $commitRatio)
        ) -NextSteps @('메모리를 많이 예약한 프로세스를 종료합니다.', '페이지 파일을 시스템 관리로 유지하고 재부팅 후 다시 측정합니다.') -Score 100))
    }
    elseif ($commitRatio -ge 0.75) {
        $findings.Add((New-MemoryFinding -Id 'commit-warning' -Severity 'Warning' -Confidence 'Observed' -Category 'Memory pressure' -Title '커밋 사용량이 높습니다' -Summary '커밋 사용량이 한계의 75%를 넘었습니다. 추가 작업에서 메모리 부족이 발생할 여지가 있습니다.' -Evidence @(
            ('현재 커밋: {0}' -f (ConvertTo-ByteSize $commitBytes)),
            ('커밋 한계 대비: {0:P0}' -f $commitRatio)
        ) -NextSteps @('상위 사설 메모리 프로세스를 확인합니다.', '페이지 파일을 임의로 비활성화하지 않습니다.') -Score 70))
    }

    if ($availableRatio -le 0.07) {
        $findings.Add((New-MemoryFinding -Id 'available-critical' -Severity 'Critical' -Confidence 'Observed' -Category 'Memory pressure' -Title '사용 가능한 물리 메모리가 매우 적습니다' -Summary '즉시 재사용할 수 있는 메모리가 전체의 7% 이하입니다.' -Evidence @(
            ('사용 가능: {0}' -f (ConvertTo-ByteSize $availableBytes)),
            ('물리 메모리 대비: {0:P0}' -f $availableRatio)
        ) -NextSteps @('메모리 사용량이 큰 앱을 저장 후 종료합니다.', '페이지 입출력이 지속되면 재부팅을 고려합니다.') -Score 95))
    }
    elseif ($availableRatio -le 0.15) {
        $findings.Add((New-MemoryFinding -Id 'available-warning' -Severity 'Warning' -Confidence 'Observed' -Category 'Memory pressure' -Title '사용 가능한 물리 메모리가 적습니다' -Summary '가용 메모리가 전체의 15% 이하입니다.' -Evidence @(
            ('사용 가능: {0}' -f (ConvertTo-ByteSize $availableBytes)),
            ('물리 메모리 대비: {0:P0}' -f $availableRatio)
        ) -NextSteps @('상위 프로세스와 커널 풀을 함께 확인합니다.') -Score 65))
    }

    if ($nonPagedBytes -ge $nonPagedCritical) {
        $findings.Add((New-MemoryFinding -Id 'nonpaged-critical' -Severity 'Critical' -Confidence 'Observed' -Category 'Kernel memory' -Title '비페이징 풀이 비정상적으로 큽니다' -Summary '드라이버가 사용하는 비페이징 메모리가 물리 메모리의 10% 또는 3GB를 넘었습니다.' -Evidence @(
            ('비페이징 풀: {0}' -f (ConvertTo-ByteSize $nonPagedBytes)),
            ('경고 기준: {0}' -f (ConvertTo-ByteSize $nonPagedCritical))
        ) -NextSteps @('PoolMon 또는 WPR로 증가하는 Pool Tag를 확인합니다.', '재부팅 직후 기준값과 장시간 추세를 비교합니다.') -Score 98))
    }
    elseif ($nonPagedBytes -ge $nonPagedWarning) {
        $findings.Add((New-MemoryFinding -Id 'nonpaged-warning' -Severity 'Warning' -Confidence 'Observed' -Category 'Kernel memory' -Title '비페이징 풀이 큽니다' -Summary '일반 프로세스 목록에 나타나지 않는 드라이버 메모리가 많이 사용되고 있습니다.' -Evidence @(
            ('비페이징 풀: {0}' -f (ConvertTo-ByteSize $nonPagedBytes)),
            ('경고 기준: {0}' -f (ConvertTo-ByteSize $nonPagedWarning))
        ) -NextSteps @('드라이버별 Pool Tag 정밀 진단을 실행합니다.', '파일 동기화, 그래픽, 네트워크 드라이버를 우선 점검합니다.') -Score 82))
    }

    if ($pagedBytes -ge $pagedWarning) {
        $findings.Add((New-MemoryFinding -Id 'paged-warning' -Severity 'Warning' -Confidence 'Observed' -Category 'Kernel memory' -Title '페이징 풀이 큽니다' -Summary '페이지 파일로 이동할 수 있는 커널 메모리도 높은 수준입니다.' -Evidence @(
            ('페이징 풀: {0}' -f (ConvertTo-ByteSize $pagedBytes)),
            ('경고 기준: {0}' -f (ConvertTo-ByteSize $pagedWarning))
        ) -NextSteps @('비페이징 풀과 함께 시간별 추세를 비교합니다.') -Score 62))
    }

    $drivers = @((Get-PropertyValue $Snapshot 'Drivers' @()))
    $software = @((Get-PropertyValue $Snapshot 'Software' @()))
    $processList = @((Get-PropertyValue $Snapshot.Processes 'Items' @()))
    $callbackDriver = $drivers | Where-Object { $_.Name -ieq 'cbfltfs4' -or $_.Path -match '(?i)cbfltfs4\.sys' } | Select-Object -First 1
    $synologyProcess = $processList | Where-Object { $_.Name -match '(?i)cloud-drive|synology' -or $_.Path -match '(?i)SynologyDrive' } | Select-Object -First 1
    $synologySoftware = $software | Where-Object { $_.Name -match '(?i)Synology Drive' } | Select-Object -First 1
    $kernelPoolIsHigh = $nonPagedBytes -ge $nonPagedWarning -or $pagedBytes -ge $pagedWarning

    $interruptDriverCandidates = @($drivers | Where-Object {
        (Get-PropertyValue $_ 'Company' '') -match '(?i)NVIDIA|AMD|Realtek|MediaTek|Intel|Synaptics|Qualcomm' -or
        (Get-PropertyValue $_ 'ProductName' '') -match '(?i)display|graphics|audio|network|wireless|bluetooth'
    } | Select-Object -First 8)
    $combinedInterruptPercent = $interruptPercent + $dpcPercent
    if ($interruptPercent -ge 5 -or $dpcPercent -ge 5) {
        $interruptSeverity = if ($interruptPercent -ge 15 -or $dpcPercent -ge 15 -or $combinedInterruptPercent -ge 20) { 'Critical' } else { 'Warning' }
        $interruptScore = if ($interruptSeverity -eq 'Critical') { 97 } else { 78 }
        $findings.Add((New-MemoryFinding -Id 'cpu-interrupt-pressure' -Severity $interruptSeverity -Confidence 'Observed' -Category 'CPU and drivers' -Title 'CPU 인터럽트 또는 DPC 시간이 높습니다' -Summary '관측 구간의 ISR 또는 DPC 처리 시간이 높은 수준입니다. 관련 드라이버는 조사 후보이며 이 카운터만으로 원인을 확정하지 않습니다.' -Evidence @(
            ('Interrupt Time 평균: {0:N2}%' -f $interruptPercent),
            ('DPC Time 평균: {0:N2}%' -f $dpcPercent),
            ('인터럽트: {0:N0}/초 · DPC Rate: {1:N0}' -f $interruptsPerSecond, $dpcRate),
            ('관측 시간: {0:N0}초' -f $durationSeconds)
        ) -NextSteps @('WPR/WPA의 DPC/ISR 분석으로 실행 시간을 많이 쓰는 드라이버를 확인합니다.', '최근 업데이트한 그래픽, 네트워크, 오디오 드라이버를 우선 비교합니다.', '짧은 순간 피크와 지속 부하를 구분하기 위해 5분 진단을 실행합니다.') -RelatedDrivers $interruptDriverCandidates -Score $interruptScore))
    }

    if ($handleCount -ge 250000 -or $sustainedHandleGrowth) {
        $handleSeverity = if ($handleCount -ge 500000 -or $handleDelta -ge 20000) { 'Critical' } else { 'Warning' }
        $handleScore = if ($handleSeverity -eq 'Critical') { 96 } else { 74 }
        $handleEvidence = New-Object System.Collections.Generic.List[string]
        $handleEvidence.Add(('전체 프로세스 핸들: {0:N0}' -f $handleCount))
        $handleEvidence.Add(('관측 구간 변화: {0:+#,0;-#,0;0}' -f $handleDelta))
        foreach ($growth in @($topHandleGrowth | Select-Object -First 5)) {
            $handleEvidence.Add(('{0}: {1:+#,0;-#,0;0}개 ({2:N0} → {3:N0})' -f $growth.Name, $growth.Delta, $growth.StartCount, $growth.EndCount))
        }
        $findings.Add((New-MemoryFinding -Id 'handle-growth' -Severity $handleSeverity -Confidence 'Observed' -Category 'Processes and handles' -Title '프로세스 핸들 총량 또는 증가량이 큽니다' -Summary '파일뿐 아니라 레지스트리, 이벤트, 스레드 등 모든 커널 핸들의 합계입니다. 정확한 파일 핸들 경로는 Sysinternals Handle 또는 WPR 추가 분석이 필요합니다.' -Evidence @($handleEvidence) -NextSteps @('핸들 증가 상위 프로세스를 종료하지 않은 상태로 다시 5분 관측합니다.', 'Sysinternals Handle로 해당 프로세스의 File 타입 핸들을 확인합니다.', '지속 증가 프로세스의 앱 버전과 확장 기능을 점검합니다.') -Score $handleScore))
    }

    if ($null -ne $callbackDriver -and ($null -ne $synologyProcess -or $null -ne $synologySoftware) -and $kernelPoolIsHigh) {
        $confidence = if ($sustainedPoolGrowth) { 'Probable' } else { 'Suspected' }
        $severity = if ($sustainedPoolGrowth) { 'Critical' } else { 'Warning' }
        $score = if ($sustainedPoolGrowth) { 96 } else { 88 }
        $growthEvidence = if ($sustainedPoolGrowth) {
            '관측 구간 증가율: {0}/분' -f (ConvertTo-ByteSize $nonPagedGrowthPerMinute)
        }
        else {
            '현재 측정만으로 이 드라이버의 직접 할당은 확인되지 않음'
        }
        $associatedApps = @((Get-PropertyValue $callbackDriver 'AssociatedApps' @()) | ForEach-Object { $_.Name } | Select-Object -Unique)
        $associatedAppEvidence = if ($associatedApps.Count -gt 0) { '연관 앱(추정): {0}' -f ($associatedApps -join ', ') } else { '연관 앱을 자동 식별하지 못함' }
        $findings.Add((New-MemoryFinding -Id 'synology-callback-filter' -Severity $severity -Confidence $confidence -Category 'File-system driver' -Title 'Synology Drive 파일시스템 필터를 점검해야 합니다' -Summary '높은 커널 풀과 CallbackFilter 드라이버, Synology Drive 실행 상태가 함께 관측됐습니다. 상관관계가 강하지만 Pool Tag 확인 전에는 원인으로 확정하지 않습니다.' -Evidence @(
            ('드라이버: {0} · {1} · {2}' -f $callbackDriver.Name, $callbackDriver.Company, $callbackDriver.FileVersion),
            ('드라이버 경로: {0}' -f $callbackDriver.Path),
            $associatedAppEvidence,
            ('시작 방식: {0} · 상태: {1}' -f $callbackDriver.StartMode, $callbackDriver.State),
            $growthEvidence
        ) -NextSteps @('재부팅 직후 커널 풀 기준값을 저장합니다.', 'Synology 동기화 활동 전후의 5분 이상 추세를 비교합니다.', '확정 진단은 PoolMon Pool Tag 또는 WPR 할당 스택으로 수행합니다.', '드라이버 파일을 직접 삭제하지 않습니다.') -RelatedDrivers @($callbackDriver) -Score $score))
    }

    if ($dwmPrivateBytes -ge 1GB -and ($activeDisplays -ge 2 -or $gpuAdapterCount -ge 2)) {
        $severity = if ($dwmPrivateBytes -ge 2GB) { 'Warning' } else { 'Info' }
        $graphicsDrivers = @($drivers | Where-Object {
            (Get-PropertyValue $_ 'Company' '') -match '(?i)NVIDIA|AMD|Intel' -or
            (Get-PropertyValue $_ 'Name' '') -match '(?i)nvlddmkm|amdkmdag|igdkmd'
        } | Select-Object -First 6)
        $dwmEvidence = @(
            ('DWM 사설 메모리: {0}' -f (ConvertTo-ByteSize $dwmPrivateBytes)),
            ('활성 디스플레이: {0} · GPU 어댑터: {1}' -f $activeDisplays, $gpuAdapterCount),
            ('공유 GPU 메모리: {0}' -f (ConvertTo-ByteSize $gpuSharedBytes))
        )
        foreach ($graphicsDriver in $graphicsDrivers) {
            $dwmEvidence += '관련 드라이버 후보: {0} · {1} · {2}' -f $graphicsDriver.Name, $graphicsDriver.Company, $graphicsDriver.Path
        }
        $findings.Add((New-MemoryFinding -Id 'dwm-gpu-pressure' -Severity $severity -Confidence 'Suspected' -Category 'Graphics' -Title 'DWM과 다중 GPU 구성을 함께 점검해야 합니다' -Summary 'Desktop Window Manager의 사설 메모리가 크며 다중 디스플레이 또는 하이브리드 GPU 구성이 함께 관측됐습니다.' -Evidence $dwmEvidence -NextSteps @('그래픽 오버레이를 끈 상태와 비교합니다.', 'DWM과 공유 GPU 메모리를 5분 이상 관측합니다.', '그래픽 드라이버 업데이트 직후 시작됐다면 이전 버전과 비교합니다.') -RelatedDrivers $graphicsDrivers -Score 76))
    }

    if ($sustainedPoolGrowth) {
        $findings.Add((New-MemoryFinding -Id 'nonpaged-growth' -Severity 'Critical' -Confidence 'Probable' -Category 'Kernel memory' -Title '비페이징 풀이 지속해서 증가합니다' -Summary '5분 이상의 관측 구간에서 비페이징 풀이 의미 있는 속도로 증가했습니다.' -Evidence @(
            ('관측 시간: {0:N0}초' -f $durationSeconds),
            ('총 증가: {0}' -f (ConvertTo-ByteSize $nonPagedDeltaBytes)),
            ('분당 증가: {0}' -f (ConvertTo-ByteSize $nonPagedGrowthPerMinute))
        ) -NextSteps @('PoolMon으로 증가량 기준 정렬 후 Pool Tag를 기록합니다.', 'WPR 커널 풀 추적으로 할당 스택을 확인합니다.') -Score 99))
    }

    $visibilityGapBytes = [Math]::Max([double]0, [double]($usedBytes - $processWorkingSetBytes))
    if ($visibilityGapBytes -ge 4GB) {
        $findings.Add((New-MemoryFinding -Id 'process-visibility-gap' -Severity 'Info' -Confidence 'Observed' -Category 'Memory accounting' -Title '프로세스 목록 밖의 메모리 비중이 큽니다' -Summary '물리 메모리 사용량과 프로세스 작업 집합 합계 사이에 큰 차이가 있습니다. 이 차이는 커널 풀, 캐시, 공유 페이지, GPU 메모리를 포함하므로 단순 합산으로 누수를 확정할 수 없습니다.' -Evidence @(
            ('물리 메모리 사용: {0}' -f (ConvertTo-ByteSize $usedBytes)),
            ('프로세스 작업 집합 합계: {0}' -f (ConvertTo-ByteSize $processWorkingSetBytes)),
            ('단순 가시성 차이: {0}' -f (ConvertTo-ByteSize $visibilityGapBytes))
        ) -NextSteps @('커널 풀, Standby 캐시, GPU 공유 메모리를 별도로 해석합니다.') -Score 45))
    }

    if ($findings.Count -eq 0) {
        $findings.Add((New-MemoryFinding -Id 'healthy-baseline' -Severity 'Info' -Confidence 'Observed' -Category 'Summary' -Title '즉시 조치가 필요한 메모리 이상은 보이지 않습니다' -Summary '현재 스냅샷에서 설정된 위험 기준을 넘는 항목이 없습니다.' -Evidence @(
            ('사용 가능 메모리: {0}' -f (ConvertTo-ByteSize $availableBytes)),
            ('비페이징 풀: {0}' -f (ConvertTo-ByteSize $nonPagedBytes))
        ) -NextSteps @('증상이 반복되면 더 긴 관측 시간으로 다시 진단합니다.') -Score 10))
    }

    $sortedFindings = @($findings | Sort-Object Score -Descending)
    $highestScore = [int](($sortedFindings | Measure-Object Score -Maximum).Maximum)
    $riskLevel = if ($highestScore -ge 95) { 'Critical' } elseif ($highestScore -ge 65) { 'Review' } else { 'Healthy' }
    $headline = switch ($riskLevel) {
        'Critical' { '즉시 확인이 필요한 메모리 이상이 있습니다' }
        'Review' { '드라이버 또는 프로세스 점검이 필요합니다' }
        default { '현재 메모리 상태는 안정적으로 보입니다' }
    }

    [pscustomobject]@{
        RiskLevel    = $riskLevel
        Score        = $highestScore
        Headline     = $headline
        FindingCount = $sortedFindings.Count
        Findings     = $sortedFindings
        Disclaimer   = '이 결과는 휴리스틱 진단입니다. Suspected와 Probable은 Pool Tag, 할당 스택 또는 재부팅 후 A/B 테스트 전까지 원인 확정을 의미하지 않습니다.'
    }
}

function ConvertTo-MemoryMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [object]$Report
    )

    $snapshot = $Report.Snapshot
    $assessment = $Report.Assessment
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add('# MemTools 메모리 진단 보고서')
    $lines.Add('')
    $lines.Add(('- 수집 시각: {0}' -f $snapshot.CollectedAt))
    $lines.Add(('- 위험 수준: **{0}**' -f $assessment.RiskLevel))
    $lines.Add(('- 요약: {0}' -f $assessment.Headline))
    $lines.Add(('- 관리자 권한: {0}' -f $snapshot.IsElevated))
    $lines.Add('')
    $lines.Add('## 핵심 지표')
    $lines.Add('')
    $lines.Add('| 지표 | 값 |')
    $lines.Add('|---|---:|')
    $lines.Add(('| 물리 메모리 사용 | {0} |' -f (ConvertTo-ByteSize $snapshot.Memory.UsedPhysicalMemoryBytes)))
    $lines.Add(('| 사용 가능 | {0} |' -f (ConvertTo-ByteSize $snapshot.Memory.AvailablePhysicalMemoryBytes)))
    $lines.Add(('| 비페이징 풀 | {0} |' -f (ConvertTo-ByteSize $snapshot.Memory.NonPagedPoolBytes)))
    $lines.Add(('| 페이징 풀 | {0} |' -f (ConvertTo-ByteSize $snapshot.Memory.PagedPoolBytes)))
    $lines.Add(('| 커밋 | {0} / {1} |' -f (ConvertTo-ByteSize $snapshot.Memory.CommitBytes), (ConvertTo-ByteSize $snapshot.Memory.CommitLimitBytes)))
    $lines.Add(('| CPU Interrupt / DPC | {0:N2}% / {1:N2}% |' -f (Get-PropertyValue $snapshot.Cpu 'InterruptTimePercent' 0), (Get-PropertyValue $snapshot.Cpu 'DpcTimePercent' 0)))
    $lines.Add(('| 전체 프로세스 핸들 | {0:N0} ({1:+#,0;-#,0;0}) |' -f (Get-PropertyValue $snapshot.Handles 'TotalCount' 0), (Get-PropertyValue $snapshot.Handles 'Delta' 0)))
    $lines.Add('')
    $lines.Add('## 추정 원인과 근거')

    foreach ($finding in $assessment.Findings) {
        $lines.Add('')
        $lines.Add(('### {0} · {1} · {2}' -f $finding.Severity, $finding.Confidence, $finding.Title))
        $lines.Add('')
        $lines.Add($finding.Summary)
        $lines.Add('')
        $lines.Add('**근거**')
        foreach ($evidence in $finding.Evidence) { $lines.Add(('- {0}' -f $evidence)) }
        if (@($finding.RelatedDrivers).Count -gt 0) {
            $lines.Add('')
            $lines.Add('**관련 드라이버와 연관 앱**')
            foreach ($driver in $finding.RelatedDrivers) {
                $lines.Add(('- `{0}` · {1} · {2}' -f $driver.Name, $driver.Company, $driver.FileVersion))
                $lines.Add(('  - 경로: `{0}`' -f $driver.Path))
                $driverApps = @((Get-PropertyValue $driver 'AssociatedApps' @()) | ForEach-Object { $_.Name } | Select-Object -Unique)
                if ($driverApps.Count -gt 0) { $lines.Add(('  - 연관 앱(추정): {0}' -f ($driverApps -join ', '))) }
            }
        }
        $lines.Add('')
        $lines.Add('**다음 단계**')
        foreach ($nextStep in $finding.NextSteps) { $lines.Add(('- {0}' -f $nextStep)) }
    }

    $lines.Add('')
    $lines.Add('## 해석 주의')
    $lines.Add('')
    $lines.Add($assessment.Disclaimer)
    return ($lines -join [Environment]::NewLine)
}

Export-ModuleMember -Function ConvertTo-ByteSize, Get-MemoryAssessment, ConvertTo-MemoryMarkdown