import QuartzCore
import Interstellar
import Artsy_UIButtons

enum LiveAuctionBidButtonState {
    case Active(biddingState: LiveAuctionBiddingProgressState)
    case InActive(lotState: LotState)
}

class LiveAuctionBidButton : ARFlatButton {
    let progressSignal = Signal<LiveAuctionBidButtonState>()

    override func setup() {
        super.setup()
        setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        progressSignal.next(setupWithState)
    }

    private func setupWithState(buttonState: LiveAuctionBidButtonState) {

        let white = UIColor.whiteColor()
        let purple = UIColor.artsyPurpleRegular()
        let green = UIColor.artsyGreenRegular()
        let red = UIColor.artsyRedRegular()
        let grey = UIColor.artsyGrayLight()


        switch buttonState {
        // When the lot is live
        case .Active(let state):

            switch state {
            case .TrialUser:
                setupUI("Register To Bid")
            case .LotSold:
                setupUI("Sold", background: .whiteColor(), border: .artsyPurpleRegular(), textColor: .artsyPurpleRegular())
            case .LotWaitingToOpen:
                setupUI("Waiting for Auctioneer…", background: white, border: grey, textColor: grey)

            case .Biddable(let price):
                setupUI("Bid \(price)")
            case .BiddingInProgress:
                setupUI("Bidding...", background: purple)
            case .BidSuccess(let outbid):
                if outbid {
                    setupUI("Outbid", background: red)
                } else {
                    setupUI("You're the highest bidder", background: .whiteColor(), border: green, textColor: green)
                }

            case .BidNetworkFail:
                setupUI("Network Failed", background: .whiteColor(), border: red, textColor: red)
            }


        // When the lot is not live
        case .InActive(let state):
            switch state {
                case .ClosedLot:
                    setupUI("Bidding Closed")
                case .LiveLot: break // Should never happen, as it'd be handled above
                case .UpcomingLot(_):
                    setupUI("Leave Max Bid")
            }
        }
    }

    private func setupUI(title: String, background: UIColor = .blackColor(), border: UIColor? = nil, textColor: UIColor = UIColor.whiteColor() ) {
        setTitle(title.uppercaseString, forState: .Normal)
        setTitleColor(textColor, forState: .Normal)

        let borderColor = border ?? background
        setBorderColor(borderColor, forState: .Normal, animated: false)
        setBackgroundColor(background, forState: .Normal)
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 48, height: 40);
    }
}
