//
//  LocDetailController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/3/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Contacts
import Firebase

class LocDetailController: UIViewController {
    
    var firebaseRef: DatabaseReference!
    var isFav: Bool = false
    var placesIdDic = [String: String]()
    
    //    MARK: - data source
    var location: LocationInfo?
    var annotation: LocationAnnotation?
    let locationManager = CLLocationManager()
    
    //    MARK: - UI component: mainStackView and bannerImage component
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var nameTag: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var addressTag: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var phoneTag: UILabel!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var websiteStackView: UIStackView!
    @IBOutlet weak var websiteTag: UILabel!
    @IBOutlet weak var websiteTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    let goMapAppButton: GoMapAppButton = {
        let button = GoMapAppButton()
        return button
    }()
    let goMenuButton: GoMapAppButton = {
        let button = GoMapAppButton()
        button.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.08)
        return button
    }()
    
    //    MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseRef = Database.database().reference()
        setupUI()
        fillContent()
        checkLocationServices()
        setupMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        queryFavStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let placeIds = Array(placesIdDic.values)
        guard let placeId = location?.placeId else { return }
        let isPlaceIdUploaded = placeIds.contains(placeId)
        if isFav && !isPlaceIdUploaded {
                    guard let location = location else { return }
                    if case .restaurant = location.locationType {
                        let key = firebaseRef.child("favourites/restaurants").childByAutoId().key!
                        firebaseRef.child("favourites/restaurants/\(key)").setValue(placeId)
                    }
                    else if case .garden = location.locationType {
                        let key = firebaseRef.child("favourites/parks").childByAutoId().key!
                        firebaseRef.child("favourites/parks/\(key)").setValue(placeId)
                    }
        } else if !isFav && isPlaceIdUploaded {
            let keys = (placesIdDic as NSDictionary).allKeys(for: placeId) as! [String]
            guard let keyToDelete = keys.first else { return }
            guard let locationType = location?.locationType else { return }
            let dir = locationType == .restaurant ? "restaurants" : "parks"
            firebaseRef.child("favourites/\(dir)/\(keyToDelete)").setValue(nil)
        }
    }
    
    
    fileprivate func queryFavStatus() {
        guard let locationType = location?.locationType else { return }
        let locationTypeStr: String
        switch locationType {
        case .restaurant: locationTypeStr = "restaurants"
        case .garden: locationTypeStr = "parks"
        }
        firebaseRef.child("favourites").child(locationTypeStr).observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: String] {
                DispatchQueue.main.async {
                    self.placesIdDic = value
                    let placeIds = Array(value.values)
                    guard let placeId = self.location?.placeId else { return }
                    let favButton = self.navigationItem.rightBarButtonItem!
                    self.isFav = placeIds.contains(placeId) ? true : false
                    let favImage = self.isFav ? #imageLiteral(resourceName: "alreadyFav").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "nonFav").withRenderingMode(.alwaysOriginal)
                    favButton.image = favImage
                }
            }
            else {
                DispatchQueue.main.async {
                    let favButton = self.navigationItem.rightBarButtonItem!
                    self.isFav = false
                    let favImage = self.isFav ? #imageLiteral(resourceName: "alreadyFav").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "nonFav").withRenderingMode(.alwaysOriginal)
                    favButton.image = favImage
                }
                print("No data at this path")
            }
        }) { error in
            DispatchQueue.main.async {
                let favButton = self.navigationItem.rightBarButtonItem!
                self.isFav = false
                let favImage = self.isFav ? #imageLiteral(resourceName: "alreadyFav").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "nonFav").withRenderingMode(.alwaysOriginal)
                favButton.image = favImage
            }
            print(error.localizedDescription)
        }
    }
    
    //    MARK: - setup UI
    fileprivate func setupUI() {
        setupFavButton()
        setupMainView()
        setupBannerImageView()
        setupLabels()
    }
    
    fileprivate func setupFavButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nonFav").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addToFav))
    }
    
    @objc fileprivate func addToFav() {
        DispatchQueue.main.async {
            self.isFav = !self.isFav
            let favImage = self.isFav ? #imageLiteral(resourceName: "alreadyFav").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "nonFav").withRenderingMode(.alwaysOriginal)
            let favButton = self.navigationItem.rightBarButtonItem!
            favButton.image = favImage
        }
    }
    
    fileprivate func setupGoMapAppButton() {
        mainStackView.addArrangedSubview(goMapAppButton)
        goMapAppButton.translatesAutoresizingMaskIntoConstraints = false
        goMapAppButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        goMapAppButton.addTarget(self, action: #selector(handleTouchUp), for: .touchUpInside)
    }
    
    fileprivate func setupGoMenuButton() {
        mainStackView.insertArrangedSubview(goMenuButton, at: 5)
        goMenuButton.translatesAutoresizingMaskIntoConstraints = false
        goMenuButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        goMenuButton.addTarget(self, action: #selector(handleGoToMenu), for: .touchUpInside)
        goMenuButton.textLabel.text = "See Menus"
        goMenuButton.decorationImage.image = #imageLiteral(resourceName: "rose").withRenderingMode(.alwaysOriginal)
    }
    
    @objc fileprivate func handleGoToMenu() {
        let menusController = MenusController()
        navigationController?.pushViewController(menusController, animated: true)
    }
    
    @objc fileprivate func handleTouchUp() {
        guard let annotation = mapView.annotations.first as? LocationAnnotation else { return }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        annotation.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    fileprivate func setupMainView() {
        setupGoMapAppButton()
        if let type = location?.locationType, type != .garden {
            setupGoMenuButton()
        }
        mainStackView.spacing = 8
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 15, right: 5))
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    fileprivate func setupBannerImageView() {
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.backgroundColor = UIColor.pear
        bannerImageView.layer.opacity = 0.8
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
    }
    
    fileprivate func setupLabels() {
        setupTagLabels()
        setupContentLabels()
        setupLabelStackViews()
    }
    
    fileprivate func setupTagLabels() {
        nameTag.text = "Name"
        addressTag.text = "Address"
        phoneTag.text = "Phone"
        websiteTag.text = "Website"
        let tags = [nameTag, addressTag, phoneTag, websiteTag]
        tags.forEach { (tag) in
            tag?.translatesAutoresizingMaskIntoConstraints = false
            tag?.widthAnchor.constraint(equalToConstant: 55).isActive = true
            tag?.font = UIFont.boldSystemFont(ofSize: 12)
            tag?.text?.append(":")
            tag?.textAlignment = .right
        }
    }
    
    fileprivate func setupContentLabels() {
        let contentLabels = [name, address]
        contentLabels.forEach { (contentLabel) in
            contentLabel?.font = UIFont.systemFont(ofSize: 10)
            contentLabel?.lineBreakMode = .byWordWrapping
            contentLabel?.numberOfLines = 0
        }
        
        let contentTextViews = [phoneTextView, websiteTextView]
        contentTextViews.forEach { (textView) in
            textView?.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            textView?.font = UIFont.systemFont(ofSize: 10)
            textView?.isEditable = false
            textView?.isSelectable = true
            textView?.isUserInteractionEnabled = true
            textView?.dataDetectorTypes = .all
            textView?.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
            textView?.translatesAutoresizingMaskIntoConstraints = false
            textView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
            textView?.delegate = self
        }
    }
    
    fileprivate func setupLabelStackViews() {
        let stackViews = [nameStackView, addressStackView, phoneStackView, websiteStackView]
        stackViews.forEach { (stackView) in
            stackView?.spacing = 6
            stackView?.alignment = .top
        }
    }
    
    //    MARK: - fill content
    fileprivate func fillContent() {
        guard let location = location else { return }
        setAddressInfo(name: location.name, address: location.address)
        
        //get & set contact info
        let parameters = [
            "placeid": location.placeId ?? "",
            "fields": "formatted_phone_number,website",
            "key": GoogleAPI.key
        ]
        getPlaceData(url: GoogleAPI.placeDetail, parameters: parameters)
        
        //get & set banner photo
        guard let imageURLParameters = location.imageURLParameters else { return }
        downloadPhoto(using: imageURLParameters)
    }
    
    fileprivate func setAddressInfo(name: String, address: String) {
        self.name.text = name
        self.address.text = address
    }
    
    // MARK: - get contact info
    fileprivate func getPlaceData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let placeDetailJSON: JSON = JSON(response.result.value!)
                self.parseJSON(json: placeDetailJSON)
            } else {
                print("Failed to get detail location info due to a connection issue:", response.result.error ?? "")
            }
        }
    }
    
    fileprivate func parseJSON(json: JSON) {
        if json["status"] != "OK" {
            print("Failed to parse JSON")
        } else {
            let result = json["result"].dictionaryValue
            let phone: String = result["formatted_phone_number"]?.stringValue ?? "no phone available"
            let website: String = result["website"]?.stringValue ?? "no website available"
            setContactInfo(phone: phone, website: website)
            setContactInfoForAnnotation(phone: phone, website: website)
        }
    }
    
    fileprivate func setContactInfo(phone: String, website: String) {
        phoneTextView.text = phone
        websiteTextView.text = website
        textViewDidChange(phoneTextView)
        textViewDidChange(websiteTextView)
    }
    
    fileprivate func setContactInfoForAnnotation(phone: String, website: String) {
        annotation?.website = website
        annotation?.phone = phone
    }
    
    //    MARK: - photo download
    fileprivate func downloadPhoto(using urlParameters: [String: String]) {
        guard let urlString = generateImageURLString(using: urlParameters) else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to download location image<##>", err)
                return
            }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.bannerImageView.image = image
            }
            }.resume()
    }
    
    let maxWidth = 800
    
    private func generateImageURLString(using parameters: [String: String]) -> String? {
        guard let photoReference = parameters["photoreference"] else { return nil }
        return "\(GoogleAPI.image)?maxwidth=\(maxWidth)&photoreference=\(photoReference)&key=\(GoogleAPI.key)"
    }
    
    //    MARK: - setup location manager
    fileprivate func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("Location Service unavailable")
        }
    }
    
    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    fileprivate func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    let regionSideLength: Double = 3000 // in meters
    
    fileprivate func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionSideLength, longitudinalMeters: regionSideLength)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //    MARK: - setup mapView
    fileprivate func setupMap() {
        mapView.delegate = self
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        addAnnotation()
    }
    
    fileprivate func addAnnotation() {
        guard let location = location else { return }
        annotation = LocationAnnotation(
            locationType: location.locationType,
            coordinate: location.coordinate,
            address: location.address,
            title: location.name
        )
        guard let annotation = annotation else { return }
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
}


extension LocDetailController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionSideLength, longitudinalMeters: regionSideLength)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension LocDetailController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LocationAnnotation else { return nil }
        let identifier = MKMapViewDefaultAnnotationViewReuseIdentifier
        var view: MKAnnotationView
        if let dequeuedView =  mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? AnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.annotation = annotation
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? LocationAnnotation else { return }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        annotation.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

class LocationAnnotation: NSObject, MKAnnotation {
    var locationType: LocationType
    var coordinate: CLLocationCoordinate2D
    var address: String
    var title: String?
    var subtitle: String?
    var phone: String?
    var website: String?
    
    enum LocationType: String {
        case garden
        case restaurant
    }
    
    init(locationType: LocationType, coordinate: CLLocationCoordinate2D, address: String, title: String, subtitle: String? = nil, phone: String? = nil, website: String? = nil) {
        self.locationType = locationType
        self.coordinate = coordinate
        self.address = address
        self.title = title
        self.subtitle = subtitle
        self.phone = phone
        self.website = website
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let addressComponents = address.components(separatedBy: ",")
        let addressDictionary = [
            CNPostalAddressStreetKey: addressComponents.first ?? ""
        ]
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary as [String: Any])
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = title
        mapItem.phoneNumber = phone
        mapItem.url = URL(string: website ?? "")
        return mapItem
    }
}

extension LocDetailController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "tel" {
            let phoneNumber = URL.absoluteString.replacingOccurrences(of: "tel:", with: "").replacingOccurrences(of: "%20", with: " ")
            let alert = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (alert) in
                if UIApplication.shared.canOpenURL(URL) {
                    UIApplication.shared.open(URL)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert) in
                print("User cancelled")
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        } else {
            let website = URL.absoluteString
            let alert = UIAlertController(title: website, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open", style: .default, handler: { (alert) in
                if UIApplication.shared.canOpenURL(URL) {
                    UIApplication.shared.open(URL)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert) in
                print("User cancelled")
            }))
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    //size textView to fit
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize.init(width: textView.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
