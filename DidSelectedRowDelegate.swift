//
//  DidSelectRowDelegate.swift
//  SegmentController
//
//  Created by Frank.Chen on 2016/12/6.
//  Copyright © 2016年 Frank.Chen. All rights reserved.
//

import Foundation

/// 點選cell觸發的delegate
protocol DidSelectedRowDelegate {
    func didSelectedRow(atIndex index: Int, mode: Int32)
}
