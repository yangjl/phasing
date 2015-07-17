
bmh2 <- function(GenotypeMatrix, forwardVectorSize = 30, excludeFP = TRUE, nsap = 3)
{
    nsap <- nsap - 1
    if (is.null(GenotypeMatrix)) 
        stop("Invalid input!")
    if (!is.matrix(GenotypeMatrix)) 
        stop("GenotypeMatrix should be a MATRIX")
    if (length(GenotypeMatrix[GenotypeMatrix != 9 & GenotypeMatrix != 0 & GenotypeMatrix != 2 & GenotypeMatrix != 
        1]) > 0) 
        stop("GenotypeMatrix must contain only 0, 1, 2 or 9")
    if (forwardVectorSize < 3)
    {
        stop("forwardVectorSize must be greater than 2")
    }
    zeroFreq <- colMeans(GenotypeMatrix == 0) * nrow(GenotypeMatrix)
    oneFreq <- colMeans(GenotypeMatrix == 1) * nrow(GenotypeMatrix)
    twoFreq <- colMeans(GenotypeMatrix == 2) * nrow(GenotypeMatrix)
    expandMat <- as.numeric(GenotypeMatrix)
    n <- nrow(GenotypeMatrix) * ncol(GenotypeMatrix)
    fMat <- matrix(as.integer(rep(0, n)), ncol = ncol(GenotypeMatrix))
    siregenotype <- apply(GenotypeMatrix, 2, function(x)
    {
        if (any(x == 0) && any(x == 2))
        {
            x <- 1
        }
        else
        {
            x <- 0
        }
    })
    if (length(siregenotype[siregenotype == 1]) < 2) 
	{
        print(rownames(GenotypeMatrix))
		stop("Less than two heterozygote sites was detected ... ")
	}
    result <- .C("bmh", expandMat = as.integer(expandMat), zeroFrq = as.integer(zeroFreq), oneFreq = as.integer(oneFreq), 
        twoFreq = as.integer(twoFreq), nrow = as.integer(nrow(GenotypeMatrix)), ncol = as.integer(ncol(GenotypeMatrix)), 
        result = fMat, siregenotype = as.integer(siregenotype), FVS = as.integer(forwardVectorSize), FP = as.logical(excludeFP), 
        nsap = as.integer(nsap))$result
    if (!is.null(rownames(GenotypeMatrix))) 
        rownames(result) <- rownames(GenotypeMatrix)
    if (!is.null(colnames(GenotypeMatrix))) 
        colnames(result) <- colnames(GenotypeMatrix)
    .hblock(result)
} 
