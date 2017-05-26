import SeaMass
using Base.Test
using Plots
pyplot()

cd(ENV["PWD"])

# spectrum ID of spectrum we will be plotting
spectrumID = 1

# load mzMLb input spectrum
mzmlbSpectrumIn = SeaMass.MzmlbSpectrum(
  "data/ubiquitin_5uM_1mTorr_1uscan.mzMLb",
  spectrumID
)


# load SMB input spectrum
smbSpectrumIn = SeaMass.SmbSpectrum(
  "data/out/ubiquitin_5uM_1mTorr_1uscan" *
    "/1.mzmlb2smb/ubiquitin_5uM_1mTorr_1uscan.p-0-005377748.smb",
  spectrumID
)
smbSpectrumInBinWidths = smbSpectrumIn.locations[2:end] -
  smbSpectrumIn.locations[1:end-1]

# load SMB output spectrum
smbSpectrumOut = SeaMass.SmbSpectrum(
  "data/out/ubiquitin_5uM_1mTorr_1uscan" *
    "/4.seamass-td/ubiquitin_5uM_1mTorr_1uscan.p-0-005377748.smb",
  spectrumID
)
smbSpectrumOutBinWidths = smbSpectrumOut.locations[2:end] -
  smbSpectrumOut.locations[1:end-1]

# Compare mzMLb input to 'mzmlb2smb' smb input (binned)
plot(
  mzmlbSpectrumIn.mzs,
  mzmlbSpectrumIn.intensities,
  m = 1,
  label = "mzMLb input",
  title = "Compare mzMLb input (sampled) to 'mzmlb2smb' smb input (binned)",
  xlabel = "m/z (Th)",
  ylabel = "ion count density",
  reuse = false,
)
plot!(
  smbSpectrumIn.locations,
  vcat(
    smbSpectrumIn.counts ./ (smbSpectrumIn.exposure .* smbSpectrumInBinWidths),
    0.0
  ),
  line = :steppost,
  label = "SMB input",
)
gui()

# Compare smb input to 'seamass' ⇨ 'seamass-restore' smb output
plot(
  smbSpectrumIn.locations,
  vcat(
    smbSpectrumIn.counts ./ (smbSpectrumIn.exposure .* smbSpectrumInBinWidths),
    0.0
    ),
  line = :steppost,
  label = "SMB input",
  m = 1,
  title = "Compare smb input to 'seamass' ⇨ 'seamass-restore' smb output)",
  xlabel = "m/z (Th)",
  ylabel = "ion count",
  reuse = false,
)
plot!(
  smbSpectrumOut.locations,
  vcat(
    smbSpectrumOut.counts ./ (smbSpectrumOut.exposure .* smbSpectrumOutBinWidths),
    0.0
  ),
  line = :steppost,
  label = "seaMass-restore SMB output",
)
gui()

println("Press <Enter> to finish")
readline()
