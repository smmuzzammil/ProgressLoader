//
//  iOSSwiftProgressLoader.swift
//
//  Created by Syed Muhammad Muzzammil on 27/07/2024.
//

import UIKit

/// A protocol that defines methods for showing and hiding a progress loader.
protocol ProgressLoaderProtocol {
    /// Shows a progress loader on the specified view.
    /// - Parameters:
    ///   - view: The view to which the progress loader should be added.
    ///   - color: The color of the loader.
    ///   - lineWidth: The line width of the loader.
    ///   - size: The size (diameter) of the loader.
    func showProgressLoader(in view: UIView, color: UIColor, lineWidth: CGFloat, size: CGFloat)
    
    /// Hides the progress loader from the specified view.
    /// - Parameter view: The view from which the progress loader should be removed.
    func hideProgressLoader(from view: UIView)
}

extension ProgressLoaderProtocol {
    /// Adds a progress loader to the specified view with customizable color, line width, and size.
    /// - Parameters:
    ///   - view: The view to which the progress loader should be added.
    ///   - color: The color of the loader. Default is gray.
    ///   - lineWidth: The line width of the loader. Default is 5.0.
    ///   - size: The size (diameter) of the loader. Default is 50.0.
    func showProgressLoader(in view: UIView, color: UIColor = .gray, lineWidth: CGFloat = 5.0, size: CGFloat = 50.0) {
        // Check if the loader view already exists
        if view.subviews.contains(where: { $0 is ProgressLoaderView }) {
            return // Loader is already added
        }
        
        // Create and configure the loader view
        let loaderContainerView = ProgressLoaderView(color: color, lineWidth: lineWidth, size: size)
        loaderContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loaderContainerView)
        
        // Set up constraints to center the loader view with specified size
        NSLayoutConstraint.activate([
            loaderContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderContainerView.widthAnchor.constraint(equalToConstant: size),
            loaderContainerView.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    /// Removes the progress loader from the specified view.
    /// - Parameter view: The view from which the progress loader should be removed.
    func hideProgressLoader(from view: UIView) {
        // Remove all subviews of type ProgressLoaderView from the view
        view.subviews
            .filter { $0 is ProgressLoaderView }
            .forEach { $0.removeFromSuperview() }
    }
}

/// A private class representing the progress loader view.
fileprivate final class ProgressLoaderView: UIView {
    
    private var shapeLayer: CAShapeLayer!
    private var color: UIColor
    private var lineWidth: CGFloat
    private var size: CGFloat
    
    /// Initializes a new progress loader view with the specified color, line width, and size.
    /// - Parameters:
    ///   - color: The color of the loader.
    ///   - lineWidth: The line width of the loader.
    ///   - size: The size (diameter) of the loader.
    init(color: UIColor, lineWidth: CGFloat, size: CGFloat) {
        self.color = color
        self.lineWidth = lineWidth
        self.size = size
        super.init(frame: .zero)
        setupLoader()
    }
    
    /// Required initializer with NSCoder. Not intended to be used in this example.
    required init?(coder aDecoder: NSCoder) {
        self.color = .white
        self.lineWidth = 5.0
        self.size = 50.0
        super.init(coder: aDecoder)
        setupLoader()
    }
    
    /// Sets up the progress loader by creating a half-circle shape layer and adding a rotation animation.
    private func setupLoader() {
        createShapeLayer()
        addRotationAnimation()
    }
    
    /// Creates the shape layer for the progress loader.
    private func createShapeLayer() {
        let halfCirclePath = UIBezierPath()
        
        // Define the radius and center of the circle
        let radius = size / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Draw an arc (half-circle)
        halfCirclePath.addArc(withCenter: center,
                              radius: radius,
                              startAngle: -CGFloat.pi / 2,
                              endAngle: CGFloat.pi / 2,
                              clockwise: true)
        
        // Create the shape layer
        shapeLayer = CAShapeLayer()
        shapeLayer.path = halfCirclePath.cgPath
        shapeLayer.strokeColor = color.cgColor // Set the color dynamically
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth // Set the line width dynamically
        
        // Add the shape layer to the view's layer
        layer.addSublayer(shapeLayer)
    }
    
    /// Adds a rotation animation to the progress loader.
    private func addRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * CGFloat.pi
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        layer.add(rotation, forKey: "spin")
    }
    
    /// Called to layout subviews. Ensures the shape layer path is updated to match current bounds.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the path of the shape layer based on the updated bounds
        updateShapeLayerPath()
    }
    
    /// Updates the path of the shape layer to match the current bounds.
    private func updateShapeLayerPath() {
        let radius = size / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let halfCirclePath = UIBezierPath()
        halfCirclePath.addArc(withCenter: center,
                              radius: radius,
                              startAngle: -CGFloat.pi / 2,
                              endAngle: CGFloat.pi / 2,
                              clockwise: true)
        
        shapeLayer.path = halfCirclePath.cgPath
    }
}
