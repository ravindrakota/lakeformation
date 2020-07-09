use embshist
go
drop   table WAMTAM
go
create table WAMTAM (
SecMnem char(20),
EffDt   smalldatetime,
Agency  char(3),
PoolNr  char(7),
Cusip   char(9),
Prefix  char(2),
WAMTAM  real,
UpdDt   smalldatetime)
go
grant select on WAMTAM to public
go
use embs
go
create view WAMTAM
as
select * from embshist..WAMTAM
go
grant select on WAMTAM to public
go




  val rounding = 3
  val initialValue = (0.0, 0.0, 0.0, Double.PositiveInfinity, 0.0)
  val initFreq: TopNList = new TopNList(101)
  //Skewness Calculation
  var skewness = scala.collection.mutable.Map[Int, Double]()
  //Kurtosis Calculations
  var kurtosis = scala.collection.mutable.Map[Int, Double]()

  def seqOp(u: (Double, Double, Double, Double, Double), v: (Double, Long)) = {
    val totalV = v._1 * v._2
    (u._1 + totalV, u._2 + (math.pow(v._1, 2)) * v._2, u._3 + v._2, math.min(u._4, v._1), math.max(u._5, v._1))
  }

  //Combine each record together
  def combOp(u1: (Double, Double, Double, Double, Double), u2: (Double, Double, Double, Double, Double)) = (
    u1._1 + u2._1, u1._2 + u2._2, u1._3 + u2._3, math.min(u1._4, u2._4), math.max(u1._5, u2._5))

  /*
   * Calculates Count, Sum, Mean, Variance (Sum of squares/count - (Sum/count)^2), Min, Max
   * Variance can never be negative but the decimal issue like .1+.2 is not exact same as .3 
   * Sometime Variance is becoming negative so returning absolute value. Because of decimal issue value should be less than 1.
   */
  def numericOutput(x: (Double, Double, Double, Double, Double)): (Double, Double, Double, Double, Double, Double) = {
    (x._3, x._1, x._1 / x._3, (x._2 / x._3 - math.pow((x._1 / x._3), 2)).abs, x._4, x._5)
  }

  def freqSeq(u: (TopNList), v: (Double, Long)): TopNList = {
    u.add(v._1, v._2)
    u
  }

  def freqComb(u1: TopNList, u2: TopNList): TopNList = {
    u1.topNCountsForColumnArray.foreach(r => u2.add(r._1, r._2))
    u2
  }

  def getFieldName(index: Int, schemaNamesMap: Map[Int, String]): String = schemaNamesMap.get(index) match {
    case Some(i) => i;
    case None => "FieldNameNotFound"
  }


  /**
    *
    * @param x
    * @param meanMap
    * @return [colIndex, ( SUM(Xi - Xavg)^2, SUM(Xi - Xavg)^3, SUM(Xi - Xavg)^4 )]
    */
  def meanDiffPowers(x: (Int, (Double, Long)), meanMap: Broadcast[scala.collection.mutable.Map[Int, Double]]): (Int, (Double, Double, Double)) = {
    (x._1, ((Math.pow((x._2._1 - getMean(x._1, meanMap)), 2) * x._2._2, Math.pow((x._2._1 - getMean(x._1, meanMap)), 3) * x._2._2, Math.pow((x._2._1 - getMean(x._1, meanMap)), 4) * x._2._2)))
  }

  def getMean(index: Int, meanMap: Broadcast[scala.collection.mutable.Map[Int, Double]]): Double = meanMap.value.get(index) match {
    case Some(i) => i;
    case None => 0
  }

  /**
    *
    * @param meanDiffPow meanDiffPow is array of [colIndex, ( SUM(Xi - Xavg)^2, SUM(Xi - Xavg)^3, SUM(Xi - Xavg)^4 )]
    * @param countMap
    * @param stdevMap
    * @return
    */
  def skewnessCalc(meanDiffPow: Array[(Int, (Double, Double, Double))], countMap: scala.collection.mutable.Map[Int, Double], stdevMap: scala.collection.mutable.Map[Int, Double]): scala.collection.mutable.Map[Int, Double] = {

    for (e <- meanDiffPow) {
      //Calculate Population Skewness and collect it
      val n = numericFunctions.getCount(e._1, countMap)
      if (n < 4)
        skewness += (e._1 -> 0)
      else {
        val stdtemp = numericFunctions.getStdDev(e._1, stdevMap)
        if (stdtemp < 1)
          skewness += (e._1 -> 0)
        else{
          //Skewness = sqrt(n) * sumofMeanDiffPow3/ (sumofMeanDiffPow2)^(3/2)
          skewness += (e._1 -> (math.sqrt(n) * e._2._2) / (math.pow(e._2._1, 3.0/2.0)))
        }
      }
    }
    skewness
  }

  def getCount(index: Int, countMap: scala.collection.mutable.Map[Int, Double]): Double = countMap.get(index) match {
    case Some(i) => i;
    case None => 0
  }

  def getStdDev(index: Int, stdevMap: scala.collection.mutable.Map[Int, Double]): Double = stdevMap.get(index) match {
    case Some(i) => i;
    case None => 0
  }

  /**
    * e._1 : columnIndex
    * @param meanDiffPow meanDiffPow is array of [colIndex, ( SUM(Xi - Xavg)^2, SUM(Xi - Xavg)^3, SUM(Xi - Xavg)^4 )]
    * @param countMap
    * @param stdevMap
    * @return kurtosis map
    */
  def kurtosisCalc(meanDiffPow: Array[(Int, (Double, Double, Double))], countMap: scala.collection.mutable.Map[Int, Double], stdevMap: scala.collection.mutable.Map[Int, Double]): scala.collection.mutable.Map[Int, Double] = {
    for (e <- meanDiffPow) {

      val n = numericFunctions.getCount(e._1, countMap)

      //Calculate Population Kurtosis and collect it
      if (n < 5) {
        kurtosis += (e._1 -> 0)
      }
      else {
        val stdtemp = numericFunctions.getStdDev(e._1, stdevMap)
        if (stdtemp < 1) {
          kurtosis += (e._1 -> 0)
        }
        else{
          //kurtosis = { n * sumofMeanDiffPow4/ (sumofMeanDiffPow2)^2 } - 3
          kurtosis += (e._1 -> ((n * e._2._3 / math.pow(e._2._1, 2)) - 3))
        }
      }
    }
    kurtosis
  }

}
